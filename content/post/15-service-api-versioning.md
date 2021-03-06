---
title: "การออกแบบ Service API ให้ Backward-Compatible"
date: 2017-12-15T12:04:02+07:00
lastmod: 2017-12-15T12:04:02+07:00
draft: false
tags: ["api", "design", "web service"]
categories: ["System Design"]
---

 ![Photo by Iker Urteaga on Unsplash](/img/covers/lego-01.jpg)

> "APIs, like diamonds, are forever" -- Xebia Essentials

เรานิยมเลือกใช้เพชรในแหวนแต่งงาน เพื่อแสดงความเป็นนิรันดร์

เวลาออกแบบ Service API ผมแนะนำให้ใส่ความโรแมนติกนี้ลงไปหน่อย ลองคิดว่านี่แหละคือแหวนแต่งงาน ระหว่างคุณและผู้ใช้เซอร์วิซของคุณ ที่จะอยู่ต่อไปตลอดจนชั่วเซอร์วิซสลาย

<!--more-->

# นิยามและความสำคัญของ Backward-Compatible

> "ทำไมเธอเปลี่ยนไป ไม่เหมือนตอนที่คบกันใหม่ๆ" -- ทุกความสัมพันธ์ในโลก

ในชีวิตจริง ยังไงโค้ดก็ต้องมีการเปลี่ยนแปลง แต่ข้อตกลงที่เราเคยให้สัญญากับผู้ใช้ไว้ มันเปลี่ยนแปลงไม่ได้ง่ายๆ ดังนั้น เราต้องทำ Service API ของเราให้ Backward-Compatible อยู่เสมอ

Backward-Compaitible หมายถึงผู้ใช้ (Client) ต้องไม่ได้รับผลกระทบอะไรหากมีการเปลี่ยนแปลงของ Service API

> Backward-Compatible : able to be used with an older piece of software without special adaptation or modification.

เพื่อให้เห็นความสำคัญของเรื่องนี้ ผมจะใช้วิธีการยกตัวอย่าง

สมมติว่า คุณจะอัพเกรดโค้ดจาก v1 เป็น v2 ซึ่งจะส่งข้อมูลในรูปแบบใหม่ (ไม่ Backward-Compatible) ถ้าผู้ใช้ยังต้องการใช้เซอร์วิซของคุณอยู่ จะต้องทำการแก้โค้ดให้ใช้งานกับ v2 ได้

เอาเข้าจริง ผู้ใช้จะต้องเขียนโค้ดให้รองรับทั้ง v1 และ v2 เนื่องจากข้อจำกัดในเรื่องของ Deployment Dependency  ลองดูตารางนี้ครับ

| ใคร        | Testing Stage   | Production  |
| ------------- |-------------:| -----:|
| เซอร์วิซของคุณ  | v2           | v1 |
| ผู้ใช้#1        | v2            | v1 |
| ผู้ใช้#2        | v1            | v1 |

ถ้าผู้ใช้#1 เอาโค้ดขึ้น Production ก่อน โค้ดจะพังเพราะเซอร์วิซของคุณยังไม่ได้รองรับ v2


| ใคร        | Testing Stage   | Production  |
| ------------- |-------------:| -----:|
| เซอร์วิซของคุณ  | v2           | v1 |
| ผู้ใช้#1        | v2            | **v2** |
| ผู้ใช้#2        | v1            | v1 |

ในทางตรงกันข้าม ถ้าคุณอัพเดตโค้ดให้ขึ้นเป็น v2 ก่อน อันนี้ผู้ใช้ทั้งสองคนจะซวย (และคุณก็จะซวยด้วยหลังจากหัวหน้าคุณรู้เรื่อง)

| ใคร        | Testing Stage   | Production  |
| ------------- |-------------:| -----:|
| เซอร์วิซของคุณ  | v2           | **v2** |
| ผู้ใช้#1        | v2            | v1 |
| ผู้ใช้#2        | v1            | v1 |

ดังนั้น ผู้ใช้ทุกคนต้องแก้โค้ดให้ซัพพอร์ตทั้ง v1 และ v2 แล้วเอาขึ้น Production ให้เรียบร้อยก่อนที่คุณจะ Deploy ขึ้น Production  

| ใคร        | Testing Stage   | Production  |
| ------------- |-------------:| -----:|
| เซอร์วิซของคุณ  | v2           | v1 |
| ผู้ใช้#1        | **v1+v2**     | v1 |
| ผู้ใช้#2        | **v1+v2**     | v1 |

ซึ่งผลลัพธ์จะบัดซบมาก เพราะ

1. หากคุณมีผู้ใช้ 100 คน ทุกคนต้องแก้โค้ดให้รองรับเวอร์ชั่นใหม่ 100 ครั้ง
2. คุณต้องรอให้ผู้ใช้ทั้ง 100 คนเอาขึ้น Production ให้เรียบร้อยก่อน ถึงจะเอา v2 ขึ้น Production ได้
3. ผู้ใช้จะทดสอบยังไงว่าโค้ดใช้งานได้กับทั้ง v1 และ v2 จริงๆ  นั่นแปลว่าคุณต้องมี Testing Stage สำหรับ v1 ให้กับผู้ใช้ด้วย
4. ถ้าหากคุณกำลังพัฒนา v3 อยู่จะเอาไปเทสต์ที่ไหน?

ดังนั้น เพื่อตัดปัญหาทั้งปวง คุณต้องมั่นใจว่าทุกๆเวอร์ชั่นของ API คุณ จะต้องรองรับ v1 และ v2

| ใคร        | Testing Stage   | Production  |
| ------------- |-------------:| -----:|
| เซอร์วิซของคุณ  | **v1+v2+v3**  | **v1 + v2** |
| ผู้ใช้#1        | v2            | v1 |
| ผู้ใช้#2        | v1            | v1 |

วิธีนี้ซับซ้อนน้อยกว่ามาก เพราะผู้ใช้ไม่ได้รับผลกระทบอะไรเลย ถ้าอยากใช้ v2 ก็แค่รอให้คุณ Deploy v2 ให้เสร็จก่อน แล้วค่อยแก้โค้ด

คำถามถัดไปคือ แล้วจะทำอย่างไรให้โค้ดของคุณรองรับทั้ง v1 และ v2?

ที่ใช้กันหลักๆมี 2 วิธีครับ

1. ใส่ Optional Parameter
2. ใส่เลข Version ใน Request

สองวิธีนี้ใช้คู่กันได้นะครับ ไม่จำเป็นต้องใช้วิธีใดวิธีหนึ่ง

# วิธีที่ 1: ใส่ Optional Parameter

ในความเป็นจริง v1 และ v2 เป็นเวอร์ชั่นของโค้ด **ไม่ใช่ของ API** ดังนั้น เราไม่มีความจำเป็นต้องเปลี่ยน Version ของ API เลย หากการเปลี่ยนแปลงของเราไม่มีผลกระทบต่อผู้ใช้

แทนที่จะเปลี่ยนเวอร์ชั่นของ API ให้ยุ่งยาก เราก็แค่เพิ่ม Optional Parameter เข้าไป

ถ้าเรามี Input เพิ่ม เราอาจจะให้ Input นั้นเป็น Optional ที่มีค่า Default เอาไว้  ผู้ใช้เก่าๆก็จะได้รับค่าเดิมโดยไม่มีปัญหาอะไร

หรือหากเราต้องการเปลี่ยน Format การส่ง เราอาจจะใส่ Optional Parameter ที่ระบุรูปแบบ Format ได้  

ตัวอย่างเช่น

1. เดิมที เราส่ง List รายการ 25 items  แต่ Mobile App อันใหม่ของเราอยากดึงแค่ที่ละ 10 items  กรณีนี้ เราสามารถใส่ Optional Parameter "limit" ที่ Default ค่าเป็น 25 เพื่อให้ผู้ใช้เดิมไม่ต้องได้รับผลกระทบอะไร ส่วน Mobile App ก็สามารถระบุค่านี้เป็น 10 ได้
2. เดิมที เราส่งข้อมูลกลับเป็น JSON แต่เราต้องการให้ส่งเป็น YAML  เราก็สามารถใส่ Optional parameter "output-format" เข้าไปได้ โดยให้ค่า Default เป็น JSON หาก Request ไม่ได้ระบุอะไรมา


# วิธีที่ 2: ใส่เลข Version ใน Request

ในกรณีที่เราใช้ Optional Parameter ไม่ได้ เราจำเป็นต้องระบุเลข Version ของ API ให้ชัดเจน เพื่อให้ผู้ใช้สามารถเลือกได้ ว่าต้องการผลลัพธ์จาก API เก่าหรือใหม่

โดยโค้ดฝั่งเราก็จะต้องจัดการเรียก API ในเวอร์ชั่นที่เหมาะสม ตามเลขที่ได้รับมา

เรื่องการส่งเลข Version เป็นปัญหาคลาสสิคที่เถียงกันจนเบื่อทุกครั้งที่ออกแบบ Service API ใหม่ๆ

ในอดีต เซอร์วิซนิยมส่งค่าผ่านทาง URI เลย ตัวอย่างเช่น ผมมีเซอร์วิซไว้ดึงชื่อรูปฮัสกี้ที่โชว์ในเว็บไซต์ หลังจาก v1 ได้รับความนิยมมาก ผมเลยทำ v2 ขึ้นเพื่อให้ทุกคนดึงข้อมูลเพิ่มเติมได้

```http
HTTP GET:
https://notaboutcode.com/api/v1/huskies

returns:
{
  ["โฮ่ง", "กรุ๊งกริ้ง", "เปี้ยวป้าว"]
}
```

```http
HTTP GET:
https://notaboutcode.com/api/v2/huskies

returns:
{
  {
    "name": โฮ่ง",
    "description": "ฮัสกี้เพศผู้สีขาวปนดำ รักสนุก เป็นมิตรกับทุกคน"
  },
  {
    "name": กรุ๊งกริ้ง",
    "description": "ฮัสกี้สาวสีน้ำตาล ขี้อาย แต่ก็ขี้อ้อนมาก"
  },
  {
    "name": เปี้ยวป้าว",
    "description": "น้องเล็กตัวล่าสุดในบ้าน น่ารักแต่เป็นตัวป่วนสุดๆ"
  }
}
```

ผมชอบวิธีนี้มาก เพราะแค่ดู URI ปุ๊บ ผมก็รู้เลยว่าเรียกเวอร์ชั่นไหน ดีบั้กง่าย

แต่เพื่อนร่วมทีมผมเห็นแล้วด่าเช็ดเลยครับ บอกว่า นี่มันไม่ [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer#Resource_identification_in_requests) เลย เพราะผมดันเอาเวอร์ชั่นไปใส่ใน URI  ตามหลักการของ REST แล้ว ฮัสกี้สามตัวไม่ได้เปลี่ยนอะไร แค่ข้อมูลที่ผมส่งกลับเปลี่ยน ดังนั้น ผมไม่ควรจะไปยุ่งกับ URI ผมควรจะส่งทาง header อย่างนี้ต่างหาก

```http
HTTP GET:
https://notaboutcode.com/api/huskies
api-version: 1

returns:
{
  ["โฮ่ง", "กรุ๊งกริ้ง", "เปี้ยวป้าว"] //ชื่อฮัสกี้สามตัว
}
```

```http
HTTP GET:
https://notaboutcode.com/api/huskies
api-version: 2

returns:
{
  {
    "name": โฮ่ง",
    "description": "ฮัสกี้เพศผู้สีขาวปนดำ รักสนุก เป็นมิตรกับทุกคน"
  },
  {
    "name": กรุ๊งกริ้ง",
    "description": "ฮัสกี้สาวสีน้ำตาล ขี้อาย แต่ก็ขี้อ้อนมาก"
  },
  {
    "name": เปี้ยวป้าว",
    "description": "น้องเล็กตัวล่าสุดในบ้าน น่ารักแต่เป็นตัวป่วนสุดๆ"
  }
}
```

พอดีไซน์แบบนี้ เราก็ไม่ต้องกังวลต่อคำติฉินนินทาของชาว RESTful แต่อย่างใด แต่เดี๋ยวก่อน เพื่อนร่วมทีมอีกคนกลับไม่คิดเช่นนั้น

เพื่อนร่วมทีมหมายเลขสองนั้นบอกว่าการใช้ custom header ("api-version") นั้นมันเปล่าประโยชน์สิ้นดี !

HTTP มี header มาตรฐานที่ชื่อว่า "Accept" ไว้แล้ว ถ้าจะทำให้ถูกต้องต้องส่งผ่านทางนี้ต่างหาก !!

```http
HTTP GET:
https://notaboutcode.com/api/huskies
Accept: applications/notaboutcode.v1+json

returns:
{
  ["โฮ่ง", "กรุ๊งกริ้ง", "เปี้ยวป้าว"] //ชื่อฮัสกี้สามตัว
}
```

```http
HTTP GET:
https://notaboutcode.com/api/huskies
Accept: applications/notaboutcode.v2+json

returns:
{
  {
    "name": โฮ่ง",
    "description": "ฮัสกี้เพศผู้สีขาวปนดำ รักสนุก เป็นมิตรกับทุกคน"
  },
  {
    "name": กรุ๊งกริ้ง",
    "description": "ฮัสกี้สาวสีน้ำตาล ขี้อาย แต่ก็ขี้อ้อนมาก"
  },
  {
    "name": เปี้ยวป้าว",
    "description": "น้องเล็กตัวล่าสุดในบ้าน น่ารักแต่เป็นตัวป่วนสุดๆ"
  }
}
```

นอกจากจะระบุ Version แล้ว ยังระบุฟอร์แมตได้ด้วย อนาคตเนี่ย ถ้าเราจะส่ง YAML กลับไป เราก็แค่มาเปลี่ยนตรงนี้พอ

เรื่องนี้ยังมีการเถียงกันไม่จบไม่สิ้น ใครอยากฟังคนเถียงกันต่อ หาในกูเกิ้ลมีเพียบเลยครับ

สำหรับผม ถ้าเข้าใจข้อดีข้อเสียและ Requirement ของ API ชัดเจน อยากเลือกไรก็เลือกไปเถอะครับ เสียเวลาเขียนโค้ด

# ข้อควรพิจารณาเวลาปฏิบัติจริง

## 1. ผู้ใช้เป็นใครบ้าง

หลักๆแล้ว เราจะเจอผู้ใช้ตกอยู่หนึ่งในสามเคสนี้

1. Backend Service อื่นๆ
2. Mobile application
3. Frontend Web Application (JavaScript)

ในกรณีที่ 2 กับ 3 เราควบคุมเวอร์ชั่นของผู้ใช้ไม่ได้เลย แม้เราจะเป็นคนควบคุม Deployment  ตัวอย่างเช่น ถ้าคนใช้ไม่ได้อัพเดตแอพ หรือเปิดเว็บไซต์ค้างทิ้งไว้ เราจะได้รับ Request ที่มาจากเวอร์ชั่นเก่าๆ ดังนั้น API ต้อง Backward-Compatible อย่างหลีกเลี่ยงไม่ได้

ส่วนกรณีแรก ถ้าเซอร์วิซดัังกล่าวอยู่ในการควบคุมของเรา เราสามารถบังคับลำดับของการ Deployment ได้ เช่น ให้ Deploy ทั้งสองเซอร์วิซพร้อมๆกัน (โดยไม่สนว่าจะมี Down-time สั้นๆระหว่างนั้นหรือเปล่า) กรณีนี้ เราสามารถเลี่ยงไม่ทำ Backward-Compatible ได้  (แต่อนาคต ถ้ามีคนจะมาขอเรียกใช้เซอร์วิซเรา ก็เลี่ยงไม่ได้อยู่ดี)

อันนี้เป็น Trade-off ที่ผมคิดว่าแฟร์นะ เพราะการทำให้โค้ด Backward-Compatible ต้องแลกมาด้วยความซับซ้อนของโค้ด ถ้าระบบไม่ได้ Critical แล้วเรา Deploy เสร็จได้ในไม่กี่นาที อย่างนี้ก็พอรับได้

อีกเรื่องหนึ่ง คือถ้าผู้ใช้ส่วนใหญ่เป็น Frontend Web Application ผมชอบที่จะใช้ URI มากกว่า เพราะดีบั้กง่าย ยังไงก็ต้อง Return ค่าเป็น JSON อยู่แล้ว ใช้ Accept header ไปก็ไม่มีประโยชน์อะไรเพิ่ม เว้นแต่ให้มันเป็น RESTful จริงๆ ซึ่งถ้าดูจาก[สถิติ](http://www.lexicalscope.com/blog/2012/03/12/how-are-rest-apis-versioned/) เซอร์วิซใหญ่ๆก็ซัพพอร์ตวิธี URI กันเยอะมาก



## 2. เฟรมเวิร์คที่เราใช้

หากเราเลือกที่จะส่งเลข Version ตัว Framework ที่เราใช้ จะมีผลต่อความซับซ้อนของโค้ดมาก  สิ่งที่เราอยากหลีกเลี่ยงคืออะไรจำพวกนี้

```JavaScript
// BAD EXAMPLE#1
if(version == "2.2" || version == "2.1" || version == "2.0" ){
  return huskiesV2();
}else if (version === "1.1"){
  return huskiesV1_1();
}else{
  return huskiesV1();
}
```

```JavaScript
// BAD EXAMPLE#2
huskies(version);

function huskies(version){
  var huskyList = getHuskyListFromDB();

  if(version == "1.1"){
    //Convert to object
  }
  if(version == "2.2"){
    //Add description to husky
  }
}
```

ลองมาดูตัวอย่างของ Express Plugin (https://www.npmjs.com/package/express-route-versioning) โค้ดจะดูง่ายกว่าในระดับหนึ่ง แต่ข้างในก็ยังซับซ้อนอยู่ดี

```JavaScript
var express = require('express');
    version = require('express-version-reroute');
version.use({
    'header': 'accept',
    'grab': /vnd.mycompany.com\+json; version=(\d+)(,|$)/,  //ดึงเลขเวอร์ชั่นออกมากจาก Accept header
    'error': 406,
});
var router = express.Router()
  .all('/huskies',
       version.reroute({
         1: function(req, res, next) { huskiesV1(...) }, //เรียกฟังก์ชั่นตามเวอร์ชั่นจ่างๆ
         2: function(req, res, next) { huskiesV2(...) },
       })
   );
express().use(router).listen(5000, function() {});
```

ในบางภาษาที่มี Annotation/Decoration คุณอาจจะเจออะไรแนวนี้
```C#
[Route("api/v2/huskies")]
public Output HuskyV2() {...}

[Route("api/v1/huskies")]
public Output HuskyV1() {...}
```

อันนี้ผมเองก็ไม่มีความรู้ไปทุกเฟรมเวิร์ค แต่ผู้อ่านต้องเช็คให้ดี เพราะตัวเฟรมเวิร์คนั้นรองรับวิธีที่คุณใช้รึเปล่า (ซึ่งเฟรมเวิร์คดีๆควรจะรองรับหมด) และโค้ดที่เขียนจะซับซ้อนขึ้นมากแค่ไหน อย่างไร

## 3. หากไม่มีเลขเวอร์ชั่นมาจะทำอย่างไร?

กรณีนี้ เซฟสุดคือ Fail Request ด้วย [400 Bad Request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400) หรือ [406 Not Acceptable](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/406) ครับ   

แต่หากตอนที่เปิด Service API ให้คนอื่นเรียกใช้ครั้งแรก ไม่ได้มีการกำหนดเรื่อง Version Number เอาไว้ เราต้องส่งค่าของ Version แรกกลับไปครับ เพราะเป็นไปได้ว่าผู้ใช้ยังคงคิดว่าไม่ได้มีการเปลี่ยนแปลงอะไรใน API อยู่

ที่เห็นพลาดกันมาก คือส่งไปยัง API ตัวใหม่สุด แล้วก็เจ๊งกันระนาว

## 4. จะหลีกเลี่ยง Code Duplication อย่างไร

แน่นอนว่าเราไม่ต้องการดูแลโค้ดแยกกันสำหรับทุกๆเวอร์ชั่นใช่ไหมครับ? พอเลยสัก 3-4 เวอร์ชั่นไป ชีวิตจะเริ่มเหนื่อยมาก

เท่าที่ผมสังเกต ผมเห็นวิธีการลด Duplication ในโค้ดอยู่สองแบบ

1. สร้าง Shared Component ให้ทุกเวอร์ชั่นเรียกใช้กัน
2. ให้เวอร์ชั่นเก่าๆ เรียกใช้ Method จาก Version ใหม่ล่าสุด

อันนี้ก็ขึ้นอยู่กับการเปลี่ยนแปลงของ Service API กับการออกแบบครับ ว่าวิธีไหนจะทำให้โค้ดดูแลง่ายที่สุด

# สรุป

การออกแบบ Service API ที่ดี ควรมีการคิดถึง Backward-Compatibility Change ไว้ตั้งแต่แรก

บทความนี้ชี้ให้เห็นถึงความสำคัญของ Backward-Compatibility และเสนอ 2 วิธี ในการเปลี่ยนแปลง Service API โดยไม่ให้มีผลกระทบต่อผู้ใช้เดิม

วิธีแรกคือการส่ง Optional Parameter ซึ่งใช้ได้ดีในกรณีที่เรา"เพิ่ม"คุณสมบัติใหม่ๆให้กับ API

วิธีที่สองคือการส่งเลข Version ซึ่งในวงการก็ยังคงเถียงกันไม่จบว่าควรจะส่งผ่านทางไหน  วิธีนี้มีรายละเอียดและโอกาสเกิด Code Duplication สูงกว่า จึงควรใช้อย่างระมัดระวังในคราวที่เหมาะสมจริงๆ
