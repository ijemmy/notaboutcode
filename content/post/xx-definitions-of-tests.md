---
title: "ความน่าปวดหัวของ Test ในระดับต่างๆ"
date: 2018-01-12T12:04:02+07:00
lastmod: 2018-01-12T12:04:02+07:00
draft: true
tags: ["CI", "CD"]
categories: ["Continuous Delivery"]
---

![Photo by Joanna Kosinska on Unsplash](/img/covers/photo-01.jpg)



<!--more-->


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
