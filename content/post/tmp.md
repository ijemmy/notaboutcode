---
title: "TMP"
date: 2017-01-01T16:28:41+07:00
lastmod: 2017-01-01T16:28:41+07:00
draft: true
tags: []
categories: []
author: "ijemmy"
---

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


# Caching

## ใส่ Cache ที่ไหน
## ปัญหาที่ตามมา

Cache refresh + spike when down
How to invalidate
Consistency
Failure in cache fleet can affect downstream system

