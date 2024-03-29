---
title: "เถียงเรื่อง Technical Design กันไม่จบซักที ทำไงดี?"
date: 2020-06-11T12:04:02+07:00
lastmod: 2020-06-11T12:04:02+07:00
draft: false
tags: ["conflict", "technical", "meeting", "design"]
categories: ["Technical Leadership"]
---

![Photo by rawpixel on Unsplash](/img/covers/fight-01.png)

เคยตกอยู่ในสถานการณ์ที่คนในห้องประชุมเถียงเรื่องเดียวกันติดต่อเป็นระยะเวลา 30 นาทีแล้วไม่ไปไหนไหมครับ?

ส่วนใหญ่ที่ผมเจอ มักจะเป็นเรื่องของ Technical Design ว่าจะไปในทิศทางไหนดี ซึ่งเราก็รู้กันว่าการ Design มันเป็นเรื่องของการ Trade-off หลายๆครั้งมันยากมากที่จะตอบว่าแบบไหนดีกว่า

การตัดสินใจเรื่องนี้ส่งผลกระทบในระยะยาว จึงต้องพิจารณาให้รอบคอบ แต่บางครั้ง เราก็จะเจอสถานการที่คนสองคน(หรือทีมแตกเป็นสองฝ่าย)เถียงกันไม่จบเสียที วนกลับมาประเด็นเดิมซ้ำๆ แย้งกันไปมา ไม่ไปไหน

ยิ่งถ้าประชุมก่อนพักเที่ยง ผมจะหิวข้าว ไปกินข้าวสายนี่ไม่โอเคเลย เรื่องกินเรื่องใหญ่

วันนี้ผมมีวิธีมานำเสนอ ไม่รับประกันว่าได้ผลตลอด แต่เท่าที่ใช้มานี่ได้ผลดีมาก ช่วยให้ผมไม่ต้องไปกินข้าวสายได้หลายครั้ง

<!--more-->

# 0. นี่ใช่ประเด็นที่ควรจะเถียงกันตอนนี้ไหม

ก่อนจะเริ่ม อยากให้เช็คก่อนว่าประเด็นที่เถียงกันอยู่เนี่ย ควรค่าแก่การเถียงหรือเปล่า ลองถามคำถามเหล่านี้ดู

1. ประเด็นที่ตัดสินใจนั้นคุ้มค่ากับเวลาที่เสียไปของทุกคนรึเปล่า? เป็นเรื่องที่สำคัญจริง หรือแค่เรื่องหยุมหยิม
1. ถ้าการตัดสินใจในประเด็นนี้ไม่ได้จำเป็นต้องมีทุกคนในห้อง ให้คนบางส่วนแยกออกไปคุยกันนอกรอบให้เรียบร้อยก่อน แล้วค่อยมาสรุปให้ทุกคนฟังอีกที
1. ถ้ารู้สึกว่าเรายังมีข้อมูลไม่พอตัดสินใจ เหตุผลดูเป็นการเดามากกว่าข้อมูลจริง เลื่อนหัวข้อการประชุมไปรอบถัดไป  และให้คนไปหาข้อมูลมาประกอบการตัดสินใจมานำเสนอ

ถ้าผ่านสามข้อข้างต้น แต่การถกเถียงดูไม่มีประสิทธิภาพ ประเด็นก็วนไปวนมา ไม่ไปไหน ถึงค่อยใช้วิธีนี้ครับ


# 1. หยุดพูด และเริ่มจดสรุปประเด็น

> เวลาเราที่เถียงกับคนอื่น เราจะไม่สามารถตั้งใจฟังเขาจริงได้อย่างถี่ถ้วน แค่อีกฝ่ายเริ่มพูด เราก็จะมีเสียงในหัวมาพูดแทรกเพื่อขัดเขาแล้ว

เวลาเถียงกันจริงๆ มันจะเละเทะนัวเนียไปหมด ไม่ได้มีโครงสร้างชัดเจน ใครคิดอะไรเข้าข้างตัวเองได้ก็ยัดเข้าไป รีบพูดแบบไม่ฟังกันเพราะกลัวลืม

เวลามีเถียงกันแบบนี้ เราต้องนิ่ง ตั้งใจฟัง และจดเป็นประเด็นเป็นหัวข้อๆไป ถ้าเราคิดว่ามีเหตุผลที่ดี อย่าพึ่งไปร่วมวงด้วย อย่าพึ่งพูด จดไปก่อน

เพราะถ้าเราเริ่มเข้าวงด้วย เราจะตั้งใจฟังได้น้อยลง เวลาคนเถียงกัน เรามักไม่ได้ถูกขับดันด้วยตรรกกะครับ แต่ใช้อารมณ์มากกว่า

เรามักจะคิดว่าโปรแกรมเมอร์นั้นใช้ตรรกกะในการถกเถียง แต่เชื่อผมเถอะครับ ไม่มีใครหนีความเป็นคนพ้นหรอก เวลาผมเถียงกับคนอื่น ผมก็ไม่ค่อยฟังเค้าเหมือนกัน ยิ่งเรามีประสบการณ์มากเท่าไร อีโก้เราก็โตตามไปด้วย

# 2. หยุดการโต้เถียงทางวาจา และสรุปประเด็นเป็นตัวอักษร

หนึ่งในสาเหตุที่คนไม่ค่อยยอมฟังคนอื่น เพราะเรารู้สึกว่าเค้าไม่ได้ฟังเรา และไม่เข้าใจมุมมองของเรา

> คนส่วนใหญ่ไม่ได้หงุดหงิดเวลาคนอื่นเห็นต่าง แต่หงุดหงิดเวลารู้สึกว่าคนอื่นไม่ตั้งใจฟังเขา

ดังนั้น เราต้องหยุดทุกคนจากโหมด"พ่น" ให้เป็นโหมดฟังก่อน แต่ถ้าบอกตรงๆว่าให้หุบปากแล้วฟัง อันนี้อาจจะเป็นราดน้ำมันบนกองเพลิง ลองพูดแนวนี้ดูครับ

> "ผมชอบประเด็นที่ทุกคนยกมามากเลย อย่างเช่นที่สุธีบอกว่าการเขียน End-to-end Testing อาจจะยุ่งยากขึ้นถ้าเราใช้ ​Microservice หรือที่อรุชมองว่าเราสามารถ Release แยกกันได้ ทำให้อัพเดตฟีเจอร์ได้เร็ว..."

สังเกตดูนะครับ ประโยคนี้ใช้วิธีการเรียกชื่อคนที่กำลังถกเถียงกันอยู่ แล้วสรุปให้เค้ารู้สึกว่า  "ใครไม่ฟัง ผมฟังอยู่" และผมไม่ได้ฟังธรรมดา ผมจดไว้ด้วย

> "...ผมพยายามจดประเด็นข้อดีของทั้งสองทางเลือก  ผมอยากจะสรุปลงกระดาน เพื่อเราจะได้เห็นภาพรวม และไม่พลาดประเด็นไหนในการตัดสินใจ"

เสร็จแล้วถ้ามี Whiteboard ก็เอาที่สรุปไว้ไปเขียนเลย หรือตอนนี้ต้องประชุมออนไลน์ ก็ใช้วิธีแชร์หน้าจอเอา

ทำให้สั้นๆและอ่านง่ายหน่อย (แนะนำให้ใช้มาร์กเกอร์สีดำ) เช่นกรณีเถียงกันว่าจะขึ้นระบบใหม่เป็น Microservices ดีหรือทำแบบ ​Monolith โดยแยก Package ก็สรุปเป็น 2 คอลัมน์ ประมาณนี้

| ข้อดีของ Microservices | ข้อดีของ Monolith แยก Package|
| :---| :------ |
| เพิ่มเซอร์เวอร์แยกกันได้ |  |
| ใช้ได้หลายภาษา |  |
|  | เขียน End-to-End Testing ง่าย |
|  | แชร์ Common code ง่าย |
| Blast Radius เล็กกว่า |  |
| ... | ... |


เขียนเสร็จแล้ว ขอให้ทุกคนหยุดพูดแล้วอ่าน

> "อยากให้ทุกคนช่วยเช็คด้วย ว่าผมพลาดประเด็นไหนไปรึเปล่า"

ซึ่งถ้าคุณฟังมาดี จดมาดี ไม่มีพลาดหรอกครับ แต่บางคนอาจจะมีประเด็นใหม่โผล่ขึ้นมา เราก็ฟัง แล้วก็จดใส่เข้าไปให้ครบ  อย่าลืมว่าทุกคนต้องการให้มีคนฟังความเห็นของตัวเอง อาจจะกินเวลาเพิ่มหน่อยอีกไม่กี่นาที แต่คุณต้องทำให้ทุกคนรู้สึกว่าคุณฟังทุกคน เราจดครบทุกประเด็นแล้ว



# 3. วิเคราะห์ทีละประเด็น

การเขียนทุกอย่างลงบนกระดานจะช่วยแยกไอเดียหรือประเด็นการโต้เถียงออกจากตัวบุคคล

> เรามักจะผูกอีโก้ไว้กับความเห็นของตัวเอง เวลาที่มีคนไม่เห็นด้วย เราจะรู้สึกว่าคนไม่เห็นด้วยกับเรา ทั้งๆที่เค้าแค่ไม่เห็นด้วยกับ"ความเห็น"ของเรา

ถึงจุดนี้ ทุกคนจะเริ่ม"ฟัง"อย่างจริงจังผ่านการอ่าน ประเด็นที่วิ่งวุ่นในหัวจะได้รับการจัดโครงสร้างชัดเจน ภาพรวมก็จะชัดขึ้น

ถ้ายังตัดสินใจไม่ได้ง่ายๆ เพราะข้อดีของแต่ละฝั่งมันเปรียบเทียบกันตรงๆไม่ได้ บางอย่างอาจจะมีน้ำหนักมาก น้ำหนักน้อย แล้วแต่สายตาของแต่ละคน

หลังจากทุกคนอ่านแล้ว ให้พยายามวิเคราะห์แต่ละประเด็นแยกกัน อันนี้ก็แล้วแต่คนเลยว่าจะวิเคราะห์กันยังไง ผมขอยกตัวอย่างการใช้ Quantify & Context

Quantify คือพยายามทำทุกอย่างให้เป็นตัวเลข เช่น ไอ้เขียน End-to-End Testing ง่ายกว่าเนี่ย มันใช้เวลาเร็วกว่ากี่เปอร์เซ็นต์เมื่อเทียบกับอีกทางเลือก

Context คือชี้ให้เห็นว่าเรากำลังเอาดีไซน์นี้ใช้กับสถานการณ์ของเรา ไม่ใช่สถานการทั่วๆไป เช่น คิดว่าเราจะมีเซอร์วิสไหนบ้างที่ต้องใช้ Go เพื่อให้ได้ประสิทธิภาพที่ดีขึ้น โปรดักต์ของเราต้องใช้เวลากี่เดือนกว่าจะถึงจุดที่ต้อง Scale เสร็จแล้วอย่าลืม Quantify ด้วยว่าเร็วขึ้นซักเท่าไร ถ้าเร็วขึ้นเท่าตัว ยัดเซอร์เวอร์เข้าไปอีกตัวนึงเพื่อนใช้เงินแลกเวลาจะคุ้มกว่าไหม

ในแต่ละหัวข้อหยิบมาร์คเกอร์สีเขียวมา เขียนข้อความเติมลงไป เก็บสรุปของแต่ละประเด็นไว้บนกระดาน ไม่งั้นคนจะลืม

ตรงจุดนี้ พยายามระวังการใช้สรรพนาม และคุมอารมณ์ให้ดี ให้แย้งที่ประเด็น เน้นที่เนื้อหา อย่าให้มีอารมณ์เข้าไปเกี่ยว เช่น

> "ที่อรุชบอกว่าใช้ได้หลายภาษา แต่เราจะมีเวลาเขียน Go กันเหรอ ถ้ามันช้าจริง ใส่เครื่องเพิ่มหรือ Optimize ด้วยวิธีอื่นก็ได้"

เปลี่ยนเป็น

> "ถึงเราจะเลือกภาษาอื่นเพื่อปรับปรุง Bottleneck แต่ด้วยสถานการณ์ของเราที่ลักษณะโปรดักต์ยังไม่แน่นอน และมีทีมพัฒนาแค่ไม่กี่คนที่เขียน Go ได้ ผมเลยรู้สึกว่าข้อดีนี้มีน้ำหนักน้อยกว่าข้ออื่น"

# 4.เราไม่มีทางตัดสินใจได้อย่างมั่นใจ 100%

หลังจากพิจารณาครบทุกประเด็น ชี้ให้ทุกคนเห็นว่า เราไม่มีทางตัดสินใจได้อย่างมั่นใจ 100%

> เราคุยกันเรื่องนี้มาเกิน 30 นาทีแล้ว เรามีกัน 7 คน รวมเป็น 210 นาที ผมคิดว่าทั้งสองทางเลือกเป็นทางที่ดี แต่เราไม่มีทางรู้หรอกว่าทางไหนดีกว่า จนกระทั่งเราได้ทำจริงๆทั้งสองทาง ซึ่งนั่นก็เป็นไปไม่ได้
>
> แต่ผมคิดว่าพวกเราได้คิดครอบคลุมกันมากที่สุดแล้ว ต่อให้เราคุยกันนานกว่านี้ เราก็ไม่สามารถทำให้การตัดสินใจดีกว่านี้ได้ ทุกคนเห็นด้วยไหม

จบประโยคนี้ ถ้าไม่มีใครคัดค้าน คุณทำสำเร็จแล้ว จะเสนอให้เลือกทางไหนก็ตามสไตล์ของทีมเลย

จะโหวตกันก็ได้ (ส่วนตัวผมคิดว่าวิธีนี้ไม่เวิร์ค) หรือให้คนที่มีประสบการณ์ในด้านนี้มากสุดตัดสินใจ หรือให้คนที่ต้องนำโปรเจ็คนี้ตัดสินใจ หรือจะบอกไปว่าคุณขอตัดสินใจ ถ้าทุกคนรู้สึกว่าคุณเป็นกลางพอ




# สรุปส่งท้าย
นี่เป็นวิธีที่จะทำให้การประชุมรวดรัดขึ้นได้โดยเรายังได้ข้อสรุป(ที่น่าจะ)ดีที่สุด อย่าก็อบไปใช้เป้ะๆนะครับ ดึงแนวคิดหลักๆ และนำไปปรับใช้กับสถานการณ์

ปัญหาหลักของการเถียงกันไม่จบ ส่วนใหญ่ไม่ใช่ปัญหาเรื่องตรรกกะ แต่เป็นปัญหาเรื่องคน ทุกคนหนีความจริง 3 ข้อนี้ไม่พ้น แค่เป็นมากเป็นน้อยกันเท่านั้น

> 1. เวลาเราที่เถียงกับคนอื่น เราจะไม่สามารถตั้งใจฟังเขาจริงได้อย่างถี่ถ้วน แค่อีกฝ่ายเริ่มพูด เราก็จะมีเสียงในหัวมาพูดแทรกเพื่อขัดเขาแล้ว
> 2. คนส่วนใหญ่ไม่ได้หงุดหงิดเวลาคนอื่นเห็นต่าง แต่หงุดหงิดเวลารู้สึกว่าคนอื่นไม่ตั้งใจฟังเขา
> 3. เรามักจะผูกอีโก้ไว้กับความเห็นของตัวเอง เวลาที่มีคนไม่เห็นด้วย เราจะรู้สึกว่าคนไม่เห็นด้วยกับเรา ทั้งๆที่เค้าแค่ไม่เห็นด้วยกับ"ความเห็น"ของเรา

คุณอาจจะเถียงจนเอาชนะอีกฝ่ายได้ แต่ถ้าอีกฝ่ายไม่รู้สึกตกลงด้วยอย่างแท้จริง พอทำงานไปสักพัก ก็จะมีปัญหางอกออกมาอยู่ดี เช่น ไม่ทำตามที่ตกลงกันไว้ หรือทำแบบขอไปที ดังนั้น พยายามคิดเรื่องความรู้สึกของคนในทีมให้มากขึ้น เวลาถกเถียงกันเรื่องพวกนี้
