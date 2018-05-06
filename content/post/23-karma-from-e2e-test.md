---
title: "เขียนเทสต์อย่างไรให้ไม่บาป (ฉบับที่ 2 Integration/E2E Test)"
date: 2018-05-05T12:04:02+07:00
lastmod: 2018-05-05T12:04:02+07:00
draft: false
tags: ["CI", "CD", "Testing"]
categories: ["Continuous Delivery"]
---

# ควรอ่านอะไรมาก่อน

# นิยาม E2E Test vs Integration Test

เนื่องจากสองอย่างนี้มี Dependency จึงเขียนแยกออกมา

# End-to-End Test: Unstable dependencies
1. Replicable Stack (ex. Docker)
2. Agreement

# 1. Uncontrollable start condition
เคยเขียนไปแล้ว แต่ Side-Effect


# 2. No reusable components (ex. Page Object)
คล้ายๆเป็นลูกเมียน้อย

# 3. Don't Wait Properly
คิดว่าทุกอย่างเกิดขึ้นทันทีใน UI Test
Integration Test ข้ามระบบอาจจะมี Eventual consistency

# 4. ไม่รีบแก้ Flaky Tests
ไม่ปิดสาเหตุตั้งแต่เนิ่นๆ พอจำนวนเทสต์เยอะแล้วหาเจอยาก (อาจจะมีไซด์ Effect)

Reproduce ยากมาก เพราะมีเรื่อง Timing, Dependency เข้ามาเกี่ยวข้อง

Log ก็จะมีผล

# 5. เขียนเทสต์มากไป (all permutations)
ช้า เปราะ และดูแลยาก
