# Deployment ของ Frontend และ Backend แยกกัน
สมมติว่า เรามีทีม Frontend และ Backend แยกกัน และไม่อยากให้ทั้งสองทีมต้องมา Co-ordinate กันว่าใครจะ Deploy ก่อนหลัง สำหรับแต่ละเวอร์ชั่น

สำหรับทีมที่ทำ Continuous Deployment ก็ให้ลองนึกว่าทั้งสองทีมมี Pipeline แยกกัน

ปัญหาคือ เราไม่สามารถการันตีได้ว่า Frontend จะขึ้น Production หลัง Backend ได้ ดังนั้น Frontend เองก็จะต้องมีคุณสมบัติเรื่อง Backend-Compatible ด้วย ซึ่งอย่างที่บอกไปข้างต้นว่าใช้ Effort ค่อนข้างมาก

ถ้าจะเลี่ยง Effort นี้ ในขั้นตอนการ Deploy ก็ต้องมีการเช็คว่าเวอร์ชั่นของ Frontend จะต้องเท่ากัน หรือน้อยกว่าเวอร์ชั่นของ Backend ในขณะนั้นเสมอ

ใครที่ทำ Continous Deployment Pipeline ก็ต้องมีการเช็คก่อน Deploy ตามเงื่อนไขนี้ ตัวอย่างเช่น

Type | Development Staging | UAT Staging | Production  
--------|------|------|----
Frontend version | 1.3 | 1.1 | 1.1
Backend version| 1.3 | 1.2 | 1.1

จากตารางข้างบน แม้ฝั่ง Frontend จะพร้อมเอา 1.3 ขึ้น UAT แล้ว แต่ Pipeline จะต้องไม่ให้ไปต่อ เพราะ 1.3 อาจจะทำให้ 1.2 พังได้


วิธีนี้ทำให้ฝั่ง Frontend กับ Backend ทำงานแยกกันได้ เหมือนจะดี แต่จะมีปัญหาเรื่องการจัดการเยอะมาก เช่น

1. หากเรามี Change ด่วน ที่ต้องเอาขึ้น Production เพื่อแก้บั๊ก Frontend ในเวอร์ชั่น 1.1  เราจะทำอย่างไร? ถ้าสร้างเวอร์ชั่น 1.4 ขึ้นมาแก้บั้กนี้ เราจะเอาเข้า Pipeline ไม่ได้เพราะ Backend ยังค้างอยู่ที่ 1.1 - 1.3
2. หาก Frontend ทำงานเร็วกว่า อาจจะมีเวอร์ชั่น 1.4 แล้ว จึงไปทำเวอร์ชั่น 1.5 ต่อ  แต่พอ Backend ทำเวอร์ชั่น 1.4 เสร็จ กลับพบว่า Integration กันไม่ได้เพราะมีฟิลด์หายไปอันนึง  ฝั่ง Frontend ตอนนั้นไปถึง 1.6 แล้ว ต้องย้อนกลับมาอัพเดตเวอร์ชั่น 1.4 แล้ว Rebase กันอ้วกแตก

อันนี้เป็นปัญหาที่ผมคิดไม่ตกอยู่ เพราะดูแล้วคงจะเลี่ยงการทำให้ Frontend เป็น Backward-Compatible ไม่ได้

หากจะเลี่ยงปัญหานี้จริงๆ อาจจะต้องบังคับให้ Frontend กับ Backend อยู่ทีมเดียวกัน เป็น Cross-Functional team เพื่อลด Effort ในการประสานงานกัน เช่น แทนที่จะไปทำเวอร์ชั่น 1.5 ล่วงหน้า ก็มาช่วยกันทำ Backend ให้เสร็จก่อนไปต่อ

------


# Component Test: No clear standard in Boundary (mixing API level with higher-order Component)

# End-to-End Test: ไม่แยก Business Layer ให้ชัดเจน (ex. page object)
# End-to-End Test: มี Side effect (ไม่เคลียร์ค่าก่อนรัน Integration tests)
# End-to-End Test: คิดว่าทุกอย่างเกิดขึ้นทันทีใน UI Test
# End-to-End Test: ไม่รีบแก้ Flaky Tests
# End-to-End Test: Do all permutations
# End-to-End Test: Unstable dependencies


# Type of Tests

# Unit Test

class, method, function?

ข้อดี เร็ว รู้ว่าพังตรงไหนชัดเจน
ข้อเสีย ไม่ได้ควบคุมอะไรเลย

Test public behavior เพื่อไม่ให้ Brittle

TDD เป็นการออกแบบว่าต้องเขียนเทสต์

ควรจะเป็น 100% ไหม?

## Test double
stub mock, etc.



# Component Test

isolate component, stub & driver

granularity    (one API, one high-order Component)

BE or Frontend?

Putting permutation at the lowest layer

which level will you mock? (Don't mix it w/ unit test)

# Integration

horrible naming - Integral between component we own? or integrate with 3rd party system?

It might be stub/mock, unclear

Set up clear testing?

# System testing
Usually more than one component? what is system?

which is stub?

# End2End
Staging against which?

flaky, fricking slow

# Regression Testing
how can we ensure?

at higher level?

on stage or on prod?

# (User) Acceptance Testing
Enduser involved

สัญลักษณ์ของ Silo

bad smell

verification of requirement?

prototyping?

# เทสต์ยิ่งสูง ยิ่งมีคุณค่า แต่ราคายิ่งแพง
