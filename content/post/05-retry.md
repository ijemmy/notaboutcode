---
title: "Retry ยังไงให้ปลอดภัย"
date: 2017-10-14T12:04:02+07:00
lastmod: 2017-10-14T12:04:02+07:00
draft: false
tags: ["reliability", "availability", "retry", "throttling", "design", "microservice", "soa" ]
categories: ["Reliability"]
---

![Photo by Nick Morris, from Unsplash.com](/img/covers/spiral-stairs-01.jpg)

วันนี้นั่งคุยกับเพื่อนเรื่อง Retry รู้สึกว่าเป็นหัวข้อที่น่าสนใจดี

โจทย์คือเรามี External service ที่ไม่ค่อยสเถียรเท่าไร เวลาส่ง Request ไป วันดีคืนดีก็อาจจะ:

1. พังแบบส่งสาเหตุการพังกลับมาให้ เช่น 5xx พร้อม error code
2. พังแบบไม่มีอะไรตอบกลับมา ซึ่งสาเหตุอาจจะมาจากที่ระบบนั้นเดี้ยงไประหว่างการทำงาน หรือเน็ตเวิร์คเน่า

กรณีนี้ เรามีหลายทางเลือก

1. เลือกที่จะจบการทำงาน แล้วแสดงผลให้ฝั่งผู้ใช้ของเรา (Client) รู้ว่าระบบมีปัญหา พร้อม Error code ซึ่งก็ถือว่ายอมรับได้ เพราะหากเราจำเป็นต้องการใช้ข้อมูลจาก External Service ยังไงก็ทำอะไรไม่ได้

2. ทำการ Retry คือการส่ง Request ซ้ำโดยอัตโนมัติ หากเกิดข้อผิดพลาดในฝั่งของ External service ที่เราเรียกใช้

3. Decouple ให้สองระบบเรียกกับแบบ Asynchronous โดยเอา Request ที่ไม่สำเร็จของเราไปเก็บไว้ใน Queue แล้ว Retry ใหม่ในภายหลัง

<!--more-->

สมมติว่าเราเลือกวิธีที่ 2. ซึ่งเหมือนไม่ซับซ้อนเหมือนวิธีที่ 3.

มองผิวเผิน เราก็แค่วนลูบ Sleep แล้วเรียกซ้ำๆ แต่เมื่อระบบสเกลขึ้นไปในระดับใหญ่ การ Retry อัตโนมัติอาจนำมาซึ่งความวิบัติที่ไม่คาดคิดได้...

เลยเป็นมาของบันทึกฉบับนี้ ว่าเราควรพิจารณาอะไรบ้างในการ Retry อัตโนมัติ

# Interval & Number of retries
เวลาจะทำ Retry อัตโนมัติ สิ่งแรกที่ต้องตัดสินใจก่อนคือจะรอเท่าไรก่อน Retry (Interval) และจะทำการ Retry กี่ครั้ง ก่อนจะหยุด

ซึ่งตัวเลขนี้ไม่มีสูตรตายตัวที่แน่นอน ขึ้นอยู่กับลักษณะของเซอร์วิซเรา โดยกรณีนี้ ผมจะเริ่มจากการ Retry หลังจากได้ Error แล้วไป 50ms  และทำการ Retry ทั้งหมด 3 ครั้ง

หากผ่านไปสามครั้งแล้ว ยังมีปัญหาอยู่ ก็ต้องยอมแสดง Error code กลับไปยังฝั่งผู้ใช้ว่าทำงานไม่ได้

# Idempotent
หลังจากเขียนโค้ดเสร็จเรียบร้อยแล้ว ทดสอบผ่าน เอาขึ้นระบบจริง ปรากฏว่าเจอบั๊ก

บั๊กที่ว่าคือ บางครั้ง Request ที่ยิงไปยัง External Service เกิดขึ้น 2-3 ครั้ง แทนที่จะเป็นครั้งเดียว

กรณีนี้เกิดขึ้นเพราะบางครั้ง ฝั่ง External Service ได้ข้อมูลของเราเรียบร้อย และทำงานเสร็จแล้ว แต่พอส่งผลกลับ ข้อมูลกลับมาไม่ถึงด้วยเหตุผลอะไรก็ตามแต่

ฝั่งเราเอง พอไมไ่ด้ผลลัพธ์กลับมา ก็คิดว่าเป็น Timeout จึงตัดสินใจส่งข้อมูลใหม่ไปอีกรอบ

เลยกลายเป็นว่า External Service ได้รับ Request เดี่ยวกันสองรอบ ลองนึกภาพว่านี่เป็นคำสั่งการโอนเงินในธนาคาร ลูกค้าเจอแบบนี้เข้าไปคงไม่สนุกด้วย

วิธีการแก้ที่ถูกต้องคือตัว API ของ External Service จะต้องเป็น Idempotent

Idempotent เป็นคุณสมบัติที่หาก Request อันเดียวกันถูกส่งซ้ำๆไปมากกว่า 1 ครั้ง ผลลัพธ์การทำงานจะต้องเกิดขึ้นแค่ครั้งเดียว

การทำให้เซอร์วิซเป็น Idempotent นั้นมีวิธีหลายแบบ ยาวพอที่จะเขียนบล็อคแยกออกไปได้เลย อันนี้ขอให้ผู้อ่านลองไปศึกษาเอาเองนะครับ

ในกรณีที่เราไม่สามารถทำให้ External Service เป็น Idempotent ได้ เราจะต้องไม่ Retry ในกรณีที่ Error เป็นชนิด Timeout


# Exponential Back-off
หลังจากแก้ไขโค้ดและเอาขึ้นระบบจริงอีกรอบ ผมได้ทำการเก็บบันทึกจำนวนครั้ง Retry ไว้ เพื่อที่จะได้เอาข้อมูลไปเช็คว่าการ Retry ช่วยแก้ปัญหาได้จริงรึเปล่า

เมื่อเอาข้อมูลไปเช็ค ปรากฏว่า ทุกครั้งที่ระบบทำการ Retry จะทำทั้งหมด 2 ครั้งตลอดก่อนจะผ่าน โดยการ Retry ครั้งที่ 1  จะไม่สำเร็จเป็นประจำ

พอคุยกับทา External Service เขาบอกว่าสาเหตุที่ Request ได้ Error มาจากว่าช่วงนั้นระบบได้รับ Request จากหลายๆที่เยอะมาก ทำให้ประมวลผลไม่ทัน พอเรารีบ Retry ใน 50 ms ระบบก็ยังคงยุ่งเกินไปอยู่ดี ทำให้ครั้งแรกยังไงก็ไม่ผ่าน

ไม่ยาก ผมแก้โค้ดให้ Retry ใน 100 ms แทน เอาขึ้นระบบจริง ปรากฏว่าจำนวน Retry เฉลี่ยนลดจาก 2 ครั้งเป็น 1 ครั้ง ทุกคนมีความสุข

ผ่านไปประมาณ 1 เดือน อยู่ดีๆกราฟจำนวน Retry เฉลี่ยก็เพิ่มขึ้นจาก 1 เป็น 1.5  ฝั่ง External Service แจ้งมาว่า เดี๋ยวนี้ระบบได้รับ Request เยอะมาก รอแค่ 100 ms ไม่พอแล้ว หากรอจำนวนเท่านี้ มันจะสำเร็จบ้าง ไม่สำเร็จบ้าง ให้เปลี่ยนค่ารอเป็น 200 ms แทน

แต่ 200 ms นี่มันช้ามาก ถ้าผมทำการรอแบบนี้ทุกครั้ง Request ที่มีการ Retry ของผมจะทำให้ Latency ของผมสูงขึ้นโดยใช่เหตุ

หนึ่งในวิธีจัดการกับปัญหานี้คือใช้ Exponential backoff คือหลังจากรอครั้งแรก การรอครั้งถัดๆไปให้ใช้วิธีการเพิ่มปริมาณการรอแบบ Exponential แทนที่จะเป็น Linear

คือจากเดิมรอ

> 50 ms, 50 ms, 50 ms

ก็อาจจะเปลี่ยนเป็น

> 50 ms, 100 ms, 250 ms

ตัวเลขอันนี้ผมตั้งไว้เพราะผมพอเดาได้ว่าต้องรอประมาณเท่าไร กรณีที่ไม่รู้อะไรเลยว่าควรรอเท่าไร เราอาจจะตั้งให้เป็น

> base x (2^1-1 , 2^2-1, 2^3-1,...)

ตัวอย่างเช่น base เป็น 50 ms ก็จะได้

> 50 ms (50x1), 150 ms (50x3), 350 ms (50x7)


# Throttling & Jitter
สมมติว่า External Service ที่เราคุยกันสามารถรองรับการทำงานได้แค่ประมาณ 100 Request ต่อวินาที

วันดีคืนดี ฝั่ง Client เรียกเรามา 100 Request พอเราส่ง Request ต่อไปพรวดเดียวให้ External Service  

ผลคือ ฝั่งนั้นไม่สามารถตอบกลับมาได้ หรือถึงตอบกลับมาได้ก็ใช้เวลา (Response Time) นานกว่าปกติ เพราะต้องจัดการ Request เกือบเต็ม Capacity ติดๆกัน

อาการนี้เรียกว่า Contention

ถ้าเกิดโชคร้าย ไม่มี Request ไหนสำเร็จเลย ระบบของเราก็จะเข้าการทำ Retry ต่อ หลังจากผ่านไป 50 ms ก็ส่งติดกันไปอีก 100 Requests เหมือนเดิมทำให้ระบบ External Service ตอบไม่ได้อีก กลายเป็น DoS (Denial Of Service) ระบบตัวเองไปซะงั้น

หนึ่งในวิธีแก้ กรณีที่เรารู้ลิมิตของฝั่ง External Service คือการทำ Throttling

Throttling คือการจำกัดจำนวนการเรียกของฝั่ง Client

ในที่นี้เราอาจจะเซ็ต Throttling ให้อยู่ที่ 70 Requests ต่อวินาที หากผู้ใช้เรียกมาเกิน Request ที่เกินมาก็จะได้รับคำตอบทันทีว่าเกินลิมิต

แต่หากว่าจังหวะนั้น มีเซอร์วิซอื่นต้องการเรียกใช้ External Service และส่งอีก 30 Requests เข้ามาพร้อมๆกันล่ะ? สุดท้ายเราก็ต้องกลับมา Retry อยู่ดี

สุดท้ายแล้ว เราก็ต้องหาวิธี Retry ที่ไม่ก่อให้เกิด Contention อยู่ดี


โดยวิธีแก้ Contention จากการ Retry นี้เรียกว่า "Jitter"

Jitter คือการสุ่มค่าการรอก่อนส่ง Retry กลับไป เช่น สุ่มรอระหว่าง 0-50 ms แทนที่จะรอ 50 ms พร้อมกันหมด

ดังนั้น จำนวนการรอจะเป็น

> 0-50 mx, 0-100ms, 0-250 ms

วิธีนี้เรียกว่า "Full Jitter" โดยจะทำให้ Request ของเรามีการกระจายตัวดีขึ้น ไม่กระจุกตัวพรวดเดียวให้เกิด Contention

อีกวิธีการที่คล้ายกันคือ "Equal Jitter"  กับ "Decorrelated Jitter" ซึ่งถ้าใครสนใจรายละเอียด สามารถอ่านต่อได้[ที่นี่](https://www.awsarchitectureblog.com/2015/03/backoff.html)

โดยส่วนตัวแล้วผมรู้สึกว่า Full Jitter ทำงานได้ดีอยู่แล้ว และลอจิกเข้าใจง่ายกว่า แต่วิธีอื่นอาจจะดีกว่ามากๆได้ ขึ้นอยู่กับลักษณะของ External Service วิธีที่จะรู้ก็คือต้องทำการทดสอบดู


# Circuit Breaker
เวลาผ่านไป โค้ดของผมทำงาานได้ดี แต่ฝั่ง External Service มีการปรับเปลี่ยนโครงสร้าง โดยแตกเป็น Micro Service ย่อยๆข้างใน

จากเดิมที่ผมเรียก

> Service A > External Service B

ก็กลายเป็น

> Service A > External Service B1 > External Service B2 > External Service B3

ซึ่งดูผิวเผินก็ไม่มีปัญหาอะไร แต่เผอิญว่า External Service B1-B2 ชอบเทคนิคการ Retry ของผมมาก เลยไปทำแบบเดียวกัน

วันหนึ่ง เซอร์วิซ B3 มีปริมาณ Request เยอะมากเพราะมันถูกเรียกใช้จาก MicroService อื่นๆด้วย พอจำนวนการเรียกใช้มันเยอะเกิน ก็เริ่มส่ง Error ติดๆกันไปสักพักหนึ่ง

Error นี้ถูกส่งกลับขึ้นไปเป็นทอดๆ ไปยังเซอร์วิซ B2, B1, และ A ของผม

โดย B2 จะทำการ Retry 3 ครั้ง  ก่อนส่งกลับไปที่ B1 และ B1 ก็จะ Retry 3 ครั้ง ก่อนส่งกลับไปที่ A

พอเริ่มเห็นภาพหายนะหรือยังครับ?

เนื่องด้วยเซอร์วิซผมทำการ Retry อัตโนมัติ จึงเรียกซ้ำอีก ซึ่งนับรวมแล้ว B3 จะได้รับ Request รวมทั้งหมด 4 x 4 x 4  (1 ครั้งแรก Retry อีก 3 ครั้ง ทุกๆระดับ) = 64  ครั้ง จาก 1 Request ที่เข้า A

เป็นอัน DoS ระบบตัวเองเรียบร้อย

เพื่อป้องกันปัญหานี้ มีเทคนิคที่เรียกว่า [Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html) คือ หากการเรียกไปที่เซอร์วิซใดๆเกิดปัญหาเกินจำนวนที่กำหนดเอาไว้ (เช่น 3 ครั้ง) ให้ทำการปิดการติดต่อเป็นระยะเวลาหนึ่ง

หากมี Request ใหม่ที่ต้องเรียกไปยังเซอร์วิซนั้นในช่วงระยะเวลาดังกล่าว ไม่ต้องทำการส่ง Request แต่ให้ส่ง Error กลับไปยังผู้เรียกเลย

พอผ่านระยะเวลานั้นไปแล้ว ให้ลองเริ่มส่ง Request อีกที

ถ้าผ่าน ก็ทำการเปิดเซอร์วิซนั้นให้เรียกตามปกติ แต่ถ้าไม่ผ่าน ก็ให้ปิดแล้วรอไปอีกช่วงระยะเวลาหนึ่ง ทำแบบนี้ไปเรื่อยๆ

วิธีนี้จะช่วยป้องกันการ DoS กันเองได้

# ในทางปฏิบัติ
ในทางปฏิบัติ น่าจะมีคนทำ Opensource Library ในการทำ Retry Exponential Backoff + Jitter หรือ Circuit Breaker ให้ใช้ในภาษาของคุณแล้ว  ถ้ามีก็หยิบไปใช้เลย เพราะการเขียนโค้ดพวกนี้ให้ถูกเป้ะๆนั้นใช้เวลานานอยู่ โดยเฉพาะอย่างยิ่งการใส่ Jitter ที่มีการยัด Randomness เข้าไป

หากไม่มีไลบรารี่ที่พอใจ ในบริษัทควรจะทำ Library กลางไว้ใช้กันเอง เพราะการทำ Service Oriented Architecture หรือ MicroService ปัญหาพวกนี้จะต้องเกิดขึ้นกับทุกทีม ทำทีเดียวให้ใช้กันทั้งบริษัทเลย