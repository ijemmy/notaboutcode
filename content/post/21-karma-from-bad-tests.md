---
title: "เขียนเทสต์อย่างไรให้ไม่บาป (ฉบับ Unit/Component Tests)"
date: 2018-04-14T12:04:02+07:00
lastmod: 2018-04-14T12:04:02+07:00
draft: false
tags: ["CI", "CD", "Testing"]
categories: ["Continuous Delivery"]
---

![Photo by Sharon McCutcheon on Unsplash](/img/covers/candle-01.jpg)

ปกติผมไม่ค่อยเชื่อเรื่องบาปบุญเท่าไร แต่เวลาเห็นโปรเจ็คไม่เขียนเทสต์ หรือเขียนเทสต์ไม่ดี ผมพูดเรื่องบาปบุญขึ้นมาทันที

> การไม่เขียนเทสต์ (หรือเขียนเทสต์ไม่ดี)เป็นบาปอย่างหนึ่ง เป็นเวรกรรมจะตามทันทีมในระยะเวลาไม่เกิน 3 เดือน

เวลาทำงานกับชาวต่างชาติที่ไม่เข้าใจคอนเซ็บเรื่องบาปบุญ ผมชอบอธิบายให้เค้าฟังแบบนี้

> Writing code without tests (or low-quality tests) is like having one-night stand everyday without protection. You will eventually regret it.

เน้นนิดนึงว่าไม่ใช่แค่เรื่องไม่เขียนเทสต์ แต่รวมถึงกรณีเขียนเทสต์ไม่มีคุณภาพด้วย

บางทีมอาจจะบอกว่าเขียนแล้ว มี Coverage ครบ 100% เลยด้วย บาปเบิบอะไรไม่มีหรอก

แต่ก่อนคนเขียนก็คิดงี้ครับ จนกระทั่งได้มาเจอกับสถานการณ์ "เทสต์ท่วมหัว เอาตัวไม่รอด"

บทความนี้จะเล่าสู่กันฟังเรื่องตัวอย่างการเขียนเทสต์ที่ไม่ดีครับ ผู้อ่านจะได้หลีกเลี่ยงกัน โดยบทความนี้จะเน้นไปในส่วนของ Unit/Component Test เป็นหลัก

แต่ก่อนจะเข้าเรื่องเขียนเทสต์ให้ดี ผมขอยกปัญหาจากการไม่เขียนเทสต์ก่อนครับ
<!--more-->

# ข้ออ้างอันดับ 1 "เขียนเทสต์แล้วช้า เสียเวลานานกว่าเขียนโค้ดอีก"

อันนี้ผมไม่ปฏิเสธครับ เพราะการเขียนเทสต์ดีๆไม่ใช่เรื่องง่ายเลย

เอากันจริงๆ ผมเองขี้เกียจเขียนเทสต์มาก แต่ก็ต้องเขียน เพราะไม่อยากให้ความขี้เกียจสร้างความพินาศให้กับโปรเจ็ค

พินาศยังไง? สมมติว่าทีมของเราเขียนโค้ดโดยไม่เขียนเทสต์ วันหนึ่ง เขียนได้ประมาณ 100 บรรทัด ทีมของเรามี 5 คน รวม 500 บรรทัดต่อวัน

หนึ่งเดือนทำงาน 20 วัน เราจะได้โค้ดประมาณ  10,000 บรรทัดต่อเดือน

ตอนแรกๆก็เขียนกันเร็วอยู่หรอกครับ แต่ปัญหาจะเริ่มเมื่อเวลาผ่านไป  

สมมติว่าเข้าเดือนที่ 3 และมีโค้ดสัก 30,000 บรรทัด จะเริ่มเกิดอาการ "แก้ตรงนั้น พังตรงนี้" อย่างหลีกเลี่ยงไม่ได้

นึกภาพนะครับ โค้ดตั้ง 30,000 บรรทัด จะตรวจกันยังไงว่าแก้ตรงนี้แล้วไม่พังที่อื่น

เราอาจจะโบ้ยว่าสาเหตุมาจากการออกแบบไม่ดี ทำให้มีผลกระทบข้ามส่วนกัน แต่เอาเข้าจริง ไม่มีใครดีไซน์โค้ดให้เพอร์เฟ็คได้ตั้งแต่แรกหรอกครับ (Requirement ยังไม่ชัดด้วยซ้ำ) ดีไซน์ในระดับโค้ดต้องมีการเปลี่ยนไปเรื่อยๆ (Refactoring) ซึ่งจะทำได้ยากมาก ถ้าไม่มี Automated Test มาคอยเช็คว่าเราเปลี่ยนแล้วจะแก้ตรงไหนได้บ้าง

ยิ่งปริมาณโค้ดเยอะขึ้น เวลาพังแต่ละที การหาบั๊กก็ใช้เวลานานขึ้น แปรผันตามจำนวนโค้ด การใส่ Feature ใหม่จะใช้เวลานานขึ้นเรื่อยๆ และวันดีคืนดีก็จะมีบั้กที่หลุด Manual Testing ขึ้น Production มาให้แก้กันให้ตื่นเต้นเล่น

ถึงจุดหนึ่ง โปรเจ็คจะอยู่สถานะที่เวลาใส่ Feature ใหม่ๆ ต้องใช้เวลาแก้บั๊กที่งอกขึ้นมา นานกว่าตัวFeatureเอง

จุดนั้นคือโปรเจ็คล้มละลาย Technical Debt เรียบร้อยแล้ว

พินาศสิครับ

# แล้วถ้าเขียนเทสต์ไว้แต่ไม่ดีล่ะ?

ทีมที่มีประสบการณ์มากขึ้น จะเริ่มทำการเขียนเทสต์ ไปจนถึงขั้นเขียนแบบไม่บันยะบันยัง เพื่อให้ Coverage Test แตะ 100% ให้ได้ (หรือเพราะหัวหน้าสั่งมา)

ปัญหาที่จะตามมาแทนคือเรื่องคุณภาพของเทสต์

ถ้าเขียนเทสต์ไว้ไม่ดี ตอนแรกๆอาจจะไม่มีอะไรมากครับ แต่พอโปรเจ็คเลย 1-2 ปี  บาปกรรมก็ตามทันอยู่ดี

ที่กล้าพูดเพราะเคยชดใช้กรรมมาแล้ว

เราจะมานั่งดูแบบละเอียดกัน ว่าการเขียนเทสต์แบบไหนบ้างที่ไม่ดี ผมคงยกตัวอย่างได้ไม่ครบหมด แต่เนื้อหาน่าจะพอทำให้ผู้อ่านเห็นภาพมากขึ้น

เพื่อไม่ให้บทความยาวเกินไป เราจะมาดูแค่ปัญหาใน Unit/Component Test  (ใครไม่เข้าใจนิยามของ Component Test ลองอ่านใน[บทความเรื่องคุณสมบัติของเทสต์]({{< relref "post/18-test-properties.md" >}})ดูก่อนนะครับ) ส่วน Integration/E2E Test นี่ผมขอยกยอดไปก่อน

## 1. ไม่ Mock Dependency ให้ดี

เวลาเราเทสต์แต่ละ Unit หรือ Component เราไม่ควรจะให้ส่วนอื่นๆนอกเหนือจากส่วนที่เราเขียนอยู่ มาทำให้เทสต์พังได้

วิธีการป้องกันปัญหานี้ ก็คือการ Mock Dependency ที่เราจะต้องเรียกใช้ลงไป  ผมขอยกตัวอย่างให้เห็นภาพกัน

1.หากเรากำลัง Unit Test Class A อยู่ แล้วคลาส A ต้องใช้ Object จากคลาส B  เราก็ควรจะทำการ Mock คลาส B ปลอมๆขึ้นมา โดยข้างในไม่ได้มีการทำงานอะไร แค่เรียกใช้ Method แล้วก็รีเทิร์นค่าที่ถูกต้องกลับมา

หากเราไม่ทำแบบนี้ วันดีคืนดีแก้คลาส B  เทสต์ของคลาส A ก็พังทั้งๆที่ไม่ได้ก็พังทั้งๆที่ไม่ได้ไปทำอะไรกับมัน**

2.หาก Class A ต้องเรียก Database หรือเรียกใช้ 3rd-party service แทนที่จะเรียกจริงๆ เราก็ทำการ Mock method ที่เรียกซะ แล้วกำหนดให้ส่งค่าที่ถูกต้องคืนทันที

หากเราไม่ทำแบบนี้ เทสต์รันจะใช้เวลานานมาก เพราะ Network call ยังไงก็เกิน 10ms ในขณะที่ [Memory Access ไม่เกิน 100ns](https://gist.github.com/jboner/2841832) ที่แย่กว่าคือ ถ้าวันดีคืนดีฝั่งที่ถูกเรียกพังขึ้นมา เทสต์ของเราก็จะพังด้วย ทำให้สับสนว่าเราเขียนโค้ดเรามีบั๊ก หรือ 3rd-party service เพี้ยนชั่วคราวเฉยๆ เสียเวลามางมหาสาเหตุฟรีๆ

Unit/Component Test ที่ดีควรจะรันได้เองโดยไม่ต้องพึ่งอะไรภายนอกครับ และควรจะรันได้เร็วมากๆด้วย ดังนั้น การ Mock Dependency จึงเป็นสิ่งที่จำเป็นมาก

## 2. สร้าง Object ใหม่ในโค้ด
เมื่อใดก็ตามที่โค้ดของคุณมีการสร้าง Object ใหม่ขึ้นมา ให้ระวังตัวไว้เลย ว่ามันจะเทสต์ยาก

ยกตัวอย่างโค้ดข้างล่าง

```Java
public class A {
  private B b;
  public A() {
    b = new B();
  }

  public doSomethingWithB() {
    //use this.b here
  }
}
```

จากข้อที่แล้ว ผมแนะนำว่าให้หลีกเลี่ยงการใช้ Object B จริงๆเวลารันเทสต์ เพราะเวลาแก้ B อาจจะทำให้เทสต์ของ A พังได้  

แต่กรณีนี้ ตัวโค้ดของ A ดันผูกติดกับ B เรียบร้อย ด้วยการสร้าง new B() แล้วเราจะ Mock B ได้ยังไง?

อันนี้แต่ละภาษา จะมีวิธีการแทรก new B() ที่แตกต่างกันไปครับ (ใครใช้ JavaScript คงจะนึกวิธีน่าเกลียดๆออก) แต่เรามาทำสิ่งที่ถือว่าเป็น Best practice ในปัจจุบันดีกว่า คือการใช้ Dependency injection

ชื่อฟังดูโหด แต่จริงๆแล้ว แนวคิดหลักคือการไม่สร้าง Object B เอง แล้วให้คลาสอื่นใส่ B (Inject dependency) ลงไปแทน

```Java
public class A {
  private B b;
  public A(B b) {
    this.b = b;
  }
  // The rest is the same
}
```

สังเกตว่าเวลาเทสต์ เราสามารถสร้าง Mock จากในเทสต์แล้วยัด B ลงไปได้ ประมาณนี้

```Java
public class TestA {
  testA() {
    B fakeB = createMockB();
    A a = new A(fakeB);
  }
}
```

ในบางภาษา เราอาจจะต้องเปลี่ยน B ให้เป็น Interface แทนคลาส หรืออาจจะใช้ library เฉพาะเพื่อสร้าง `fakeB` แทนการเรียก `createMockB()`  

ส่วนเวลาตัวโค้ดจริงๆจะเรียกใช้ A ก็จะต้องสร้าง B ขึ้นมาก่อน อันนี้แต่ละภาษามักจะมีเฟรมเวิร์คที่ใช้ทำ Dependency Injection อยู่แล้ว อันนี้ต้องยกให้ผู้อ่านไปศึกษาภาษาที่ตนใช้อยู่

แต่หลักใหญ่ใจความของข้อนี้คือ **อย่าสร้าง Object ใหม่ใน Code** เพราะมันจะทำให้ Mock Depedency ในการเทสต์ยาก

## 3. ไส้ในรั่ว (Leaking Implementation Details)
เทสต์ที่ดี เวลาแก้โค้ดในอนาคต ถ้าเราไม่ได้เปลี่ยน Public interface (ex. public method ใน java) เทสต์ไม่ควรจะพังครับ  เวลา Refactor โค้ดก็จะง่าย และไม่เสียเวลามานั่งแก้เทสต์

ส่วนใหญ่ การที่เทสต์พังทั้งๆที่ไม่ได้มีการแก้ Public method จะเกิดจากการที่เทสต์ไปรับรู้"ไส้ใน" หรือ Implementation Details

คราวนี้ แทนที่เทสต์จะทดสอบแค่ข้อกำหนดที่ตกลงกันไว้ใน Public interface เราดันไปเทสต์ไอ้ Implement details เพิ่มเข้าไปอีก ด้วยความหวังดี อยากเทสต์ให้ละเอียด

ประเด็นคือ Implementation Details นี่มันอาจจะเปลี่ยนเมื่อไรก็ได้ อาจจะโดน Refactor หรือ อาจจะเปลี่ยนไป Implement ด้วยวิธีอื่น ซึ่งพอแก้ที เทสต์ก็จะพังไปด้วย ต้องเขียนใหม่อีก

คนที่ทำ TDD จะไม่ค่อยมีปัญหานี้ เพราะส่วนใหญ่จะกำหนด Interface ไว้ค่อนข้างชัดเจนตั้งแต่เขียนเทสต์ ที่เจอบ่อยคือกรณีที่มีโค้ดอยู่แล้ว (โดยเฉพาะอย่างยิ่ง Legacy Code) แล้วเรามาเขียนเทสต์คร่อมทีหลัง

ตรงนี้ต้องมีสติเวลาเขียนเทสต์หน่อย ว่าไอ้ที่เช็คอยู่นี่มันเป็น Public interface ที่คนใช้ควรจะรู้รึเปล่า ไม่ใช่เอาแต่ Assert รัวๆทุกอย่างที่ขวางหน้า ถ้าที่ทีมมีการทำ Code Review ก็ใส่จุดนี้ไปใน Check List ด้วย จะช่วยเตือนสติกันได้

## 4. เทสต์มี Side effect หรือต้องพึ่ง Side Effect จากเทสต์ข้างๆ
เวลาเขียนเทสต์เสร็จ (และเป็นสีเขียวแล้ว) ก่อนจะดี๊ด๊า Push โค้ดแล้วไปเดินเล่น ให้มองคร่าวๆว่าเทสต์ของเราทิ้ง Side Effect อะไรไว้รึเปล่า

ตัวอย่างเช่น

1. หาก Mock อะไรขึ้นมา (Method, Class, API Call, Date object etc.) แล้วเฟรมเวิร์คที่ใช้อยู่ไม่ได้เคลียร์ค่าให้อัตโนมัติ เราจัดการเคลียร์เรียบร้อยแล้วหรือยัง
2. กรณีที่เทสต์ต้องใช้แก้ค่าจาก Singleton, Database หรือ Data Access Layer ค่าพวกนี้เคลียร์เสร็จแล้วหรือเปล่า

การทิ้ง Side Effect ไว้ บางทีอาจจะไม่พังวันนี้ แต่มันจะพังวันหน้า บางทีแค่สลับลำดับเทสต์ก็พังแล้ว

ทุกครั้งที่เขียนเทสต์ แต่ละ Test ควรจะเป็นอิสระต่อกัน (Independent) ไม่ว่าเทสต์ไหนรันก่อนหลัง ก็ควรจะผ่านหมด แม้ว่าเทสต์อยู่ในไฟล์เดียวกัน ก็ไม่ควรจะมีสมมติฐานว่าต้องรันเทสต์ข้างบนก่อน เทสต์ข้างล่างถึงจะผ่าน

ถ้าโชคดีหน่อย พอ Push code แล้วรันใน CI Server แล้วพังทันที อันนี้ก็จะหาไม่ยาก เพราะรู้ว่าพึ่งแก้อะไรไป

ที่บัดซบมากๆคือกรณีที่วันดีคืนดีก็พังขึ้นมา แล้วก็พังบ้างไม่พังบ้าง (Flaky) โดยหาสาเหตุไม่เจอชัดเจน สมมติว่ามีเทสต์สักพันตัว อันนี้หากันอ้วกเลย ว่าเทสต์ไหนเป็นตัวสร้าง Side Effect แล้วไอ้เทสต์ที่พังนี่ไปพึ่ง Side Effect อะไรบ้าง

อันนี้ส่วนใหญ่หนีไม่รอด เพราะพอถึงจุดที่เทสต์เยอะมากๆ เวลารันเทสต์จะนานเกินไป ทำให้เราอาจจะต้องเปลี่ยนวิธีการรันเทสต์แบบ Sequential เป็น Parallel เพื่อประหยัดเวลา อันนี้เราอาจจะการันตีลำดับในการรันไม่ได้เลย ขึ้นอยู่กับวิธีการกระจายเทสต์ของเฟรมเวิร์ค

คนที่เขียนเทสต์ในเลเยอร์สูงๆ (Component, Integration, E2E Test) จะเจอปัญหานี้บ่อยกว่า เพราะต้องเซ็ตอัพนู่นนี่เยอะ โอกาสทิ้ง Side effect ไว้ก็จะมากกว่า

ในทางปฏิบัติ เราจะพึ่ง Best Intention ของ Developer ไม่ได้ เพราะทุกคนเป็นมนุษย์ ยังไงก็ลืมหรือพลาดกันได้ วิธีการที่ดีกว่า คือการ Enforce กฏบางอย่างที่ป้องกัน หรือตรวจสอบการรั่วของ Side Effect ให้เจอเร็วที่สุด เช่น

1. เซ็ตค่าให้ Framework รันเทสต์แบบ Parallel แบบสุ่มตั้งแต่เริ่มโปรเจ็คเลย (อย่างน้อยก็ 2 กลุ่มแยกกัน) เวลามี Side Effect จะได้ตรวจเจอเร็วๆ
2. ทุกครั้งที่เริ่มเทสต์ จะต้องมีการ Initialize ค่าที่เราต้องใช้ให้ครบ ไม่อนุมานว่าค่า Default จะยังอยู่ เพราะเทสต์อื่นอาจแก้แล้วลืมทิ้งไว้ให้เรา
3. ถ้าคลาสส่วนใหญ่ต้องทำอะไรแบบเดียวกันซ้ำๆ เราอาจจะสร้าง Utility Class ที่ไว้ใช้ตอน SetUp/TearDown ให้ครบเลย เพื่อเลี่ยงไม่ให้ Developer ลืม Initialize หรือเคลียร์ค่าบางค่า

## 5. เทสต์หลายอย่างใน Method เดียว
สำหรับผม ถ้า Component/Unit Test Method เกิดยาวเกินสัก 50 Lines นี่คือเริ่มทะแม่งๆแล้ว

การที่ Method เดียว ทำการเทสต์หลายอย่าง จะมีข้อเสียตรงที่ แต่ละส่วนของการเทสต์ต้องพึ่งส่วนที่มาก่อนด้านบน ทำให้เวลาเทสต์พัง จะไล่หายากว่ามันพังจริงๆตั้งแต่ตรงไหน เพราะการพังที่ Line 40  อาจจะมาจากข้อผิดพลาดตั้งแต่ Line 3 ก็ได้

เรามักจะประมาทความซับซ้อนในการไล่โค้ด เพราะตอนเขียนใหม่ๆเสร็จใหม่ๆ ทุกอย่างดูเข้าใจง่าย   

แต่ในทางปฏิบัติ คนที่ต้องมาไล่โค้ดจริงๆอาจจะไม่ใช่เรา หรืออาจจะเป็นเราในอีก 6 เดือนข้างหน้าซึ่งลืมไปแล้วว่าเขียนอะไรเอาไว้

ส่วนตัว ผมจะมีสัญญาณเตือนว่า

1. เวลาตั้งชื่อเทสต์ ถ้ามีคำว่า "and"
2. หลัง Assertion ครั้งแรกแล้วต้องทำอะไรเพิ่มแล้ว Assert อีกที

แปลว่าเราเทสต์มากกว่าหนึ่งอย่างแล้ว ควรจะแตกไปแยกไว้ใน Method อื่น  ถ้าแตกแล้วมันมีโค้ดซ้ำกันมาก ก็แยกออกมาเป็น Method ให้ทั้งสองเทสต์เรียกใช้ร่วมกันซะ

## 6. ปฏิบัติกับเทสต์แบบลูกเมียน้อย
สารภาพกันมา ทุกคนเคยก็อบแปะโค้ดจาก Test Method ข้างบน แล้วมาแก้แค่บางค่ากันใช่ไหม?

อันนี้เป็นสัญญาณว่าเรามี Duplicated Code ที่เราสามารถ Extract Method ออกมาใช้ซ้ำได้

แต่พอเจอแบบนี้ บางทีก็จะคิดว่า "นี่แค่เทสต์โค้ดเอง ซ้ำๆหน่อยก็ไม่เห็นเป็นอะไรเลย"

อยากให้จำไว้ว่า

> Test code มีศักดิ์ศรีเท่ากัน Production Code คุณต้อง Refactor และดูแลมันให้ดี อย่าให้เป็นลูกเมียน้อย

เพราะเวลาเทสต์พังขึ้นมา คุณก็เอาโค้ดขึ้น Production ไม่ได้เหมือนกัน

เวลาเขียนเทสต์(หรือโค้ด) ส่วนตัว ผมจะพยายามทำทุกอย่างให้อ่านง่ายครับ ไม่ต้องฉลาดมาก พอโค้ดอ่านง่าย อนาคตจะกลับมาแก้หรือดีบั๊กก็จะใช้เวลาน้อยกว่า

## 7. ไม่มี Standard ในการเขียนภายในทีม  

หลายๆทีมมี Coding Convention ที่ดี แต่ไม่มี Test Code Convention เลยด้วย

ตัวอย่างเช่นการตั้งชื่อเทสต์ คนนึงเขียนอาจจะเป็น

`testProductPurchaseAction_IfStockIsZero_RendersOutOfStockView()`

อีกคนอาจจะเป็น

`testPurchaseOutOfStock()`

และไม่ได้มีแค่สองแบบ พอเปิดดูคลาสอื่นๆ มีจำนวนแบบตามจำนวนคนในทีมเลย

ถามว่าแบบไหนดีกว่า อันนี้ผมตอบไม่ได้ เพราะเป็นเรื่องของรสนิยมซะเยอะ แต่ถ้ามันมีมากกว่าหนึ่งแบบ อันนี้ตอบได้ ว่าไม่ดีแน่ๆ เวลามาเปิดไล่โค้ดดูจะอ่านยาก ยิ่งถ้าต้องดูหลายๆคลาสพร้อมกันแล้วใช้ Standard คนละแบบกัน อันนี้จะยิ่งสับสน

เรื่องนี้ไม่ใช่แค่ชื่อเทสต์ แต่รวมไปถึงเรื่องพวกการจัดวางโค้ด การ SetUp/TearDown การจัด Folder Structure ฯลฯ

คือจะให้เหมือนกันเป๊ะคงยาก แต่อย่างน้อย ก็ไม่ถึงขั้นว่าเปิดไฟล์ข้างๆแล้วยังกับอยู่อีกโปรเจ็คนึง ใครอยากจะทำอะไรก็ทำตามใจ

ระยะยาว พอมีเทสต์เป็นร้อยเป็นพันแล้วจะดูแลยากครับ

# สรุป + การเอาไปใช้ในชีวิตจริง
การไม่เขียนเทสต์เป็นบาปติดจรวด สามเดือนก็เห็นผล

แต่การเขียนเทสต์ไม่ดี บาปจะมาช้าหน่อย แต่จะหนักหน่วงไม่แพ้กัน เพราะเราจะต้องใช้เวลาดูแลรักษาเทสต์ (Maintenance) เยอะมาก ซึ่งจะมาจาก

1. **เทสต์เชื่อถือไม่ได้ (Flaky)** เพราะพังบ้างไม่พังบ้างแบบสุ่มๆ  หาสาเหตุไม่เจอ พอเป็นบ่อยๆเข้า มีเทสต์หรือไม่มีเทสต์ก็ไม่ต่างกัน เพราะต่อให้เทสต์พังก็ต้องเอาขึ้น Production อยู่ดี  กรณีนี้จะเกิดขึ้นจากการที่ไม่ Mock Dependency ให้ดี (ข้อ 1) หรือ เทสต์มี Side Effect (ข้อ 4)
2. **เทสต์เปราะ (ฺBrittleness)** การเขียนเทสต์หรือแก้โค้ดทำได้ยาก เพราะแก้ตรงนี้ก็จะพังตรงนู้น  ทำให้ทีมรู้สึกว่าการเขียนเทสต์นั้นมีค่าใช้จ่ายมากกว่าประโยชน์ที่ได้รับ กรณีนี้เกิดจากการออกแบบเทสต์กับโค้ดไม่ดี (ข้อ 2 และ 3)
3. **หาสาเหตุที่พังยาก (Failure Isolation)** หาเจอยากว่ามันพังตรงจุดไหน สาเหตุอาจจะมาจากความซับซ้อนของเทสต์ (ข้อ 5, 6) เทสต์โค้ดอ่านยาก (ข้อ 7)  หรือเพราะมันมี Side Effect แปลกๆที่มาจากเทสต์อื่นๆ (ข้อ 4)

และนำไปสู่จุดที่ทีมจะบ่นว่า "อย่าเขียนเทสต์ดีกว่า" แล้วก็เข้าลูปบาปติดจรวดใหม่

ใครที่ในทีมกำลังเริ่มเขียนเทสต์ อยากแนะนำให้ส่งบทความนี้ให้เพื่อนร่วมทีมอ่าน แล้วคอยหมั่นตรวจสอบโค้ดของตัวเองว่าเข้าข่ายข้างต้นรึเปล่า การป้องกันไว้ง่ายกว่าการแก้ไขครับ

ส่วนใครที่เจอปัญหาพวกนี้แล้ว การแก้ไขต้องค่อยเป็นค่อยไป ใช้เวลา ต้องใจเย็นแล้วค่อยๆแก้ไปทีละจุด เริ่มจากดูก่อนว่าปัญหาที่กระทบเรามากสุดเป็นปัญหาไหน (Flaky, Brittleness, หรือ Failure Isolation) หาต้นตอของปัญหาให้เจอ (ซึ่งอาจจะเป็นสาเหตุอื่นที่บทความนี้ไม่ได้พูดถึงก็ได้) แล้วไปแก้ที่ต้นตอครับ
