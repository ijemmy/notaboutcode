# RxJS Note

## Andre Introduction (https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)

### 1. Simple Request & response
```javascript


var requestStream = Rx.Observable.of('https://api.github.com/users')
var responseStream = requestStream
  .flatMap(url => Rx.Observable.fromPromise(jQuery.getJSON(requestUrl)))

//requestStream:  --a-----b--c------------|->
// vvvvvv   flatMap() to not create new meta stream
//responseStream: -----A--------B-----C---|->

```

### 2. Trigger loading from refresh button (merging Streams)
```javascript
// 2. Trigger from button
var refreshButton = document.querySelector('.refresh');
var refreshClickStream = Rx.Observable.fromEvent(refreshButton, 'click');  
var startupRequestStream = Rx.Observable.of('https://api.github.com/users');
var requestStream = refreshClickStream
  .map(event => ) {
    var randomOffset = Math.floor(Math.random()*500);
    return 'https://api.github.com/users?since=' + randomOffset;
  })
  //.merge(startupRequestStream)
  .startWith('https://api.github.com/users') //Shorter and more eradable than merging another startupRequestStream
  .
  // And now, with the same old code
  var responseStream = requestStream
    .flatMap(url => Rx.Observable.fromPromise(jQuery.getJSON(requestUrl)))
```

### 3. How are we going to clean out DOM value when it is loading? (startWith() + reusing refreshClickstream)
```javascript
// We could do something simple like this. But your UI wouldn't be very nice.
// The UI won't be updated until responseStream is completed (so there is a delay between clicking and real update)
var suggestion1Stream = responseStream
  .map(function(listUsers) {
    // get one random user from the list
    return listUsers[Math.floor(Math.random()*listUsers.length)];
  })
  .subscribe(() => {
    //update DOM
  })

// Instead we could use .startWith() to clean initial DOM value  &  refersh value to null when there is a click (reusing an existing refreshClickStream)

// refreshClickStream: ----------o---------o---->
//      requestStream: -r--------r---------r---->
//     responseStream: ----R----------R------R-->   
//  suggestion1Stream: -N--s-----N----s----N-s-->
//  suggestion2Stream: -N--q-----N----q----N-q-->
//  suggestion3Stream: -N--t-----N----t----N-t-->
var suggestion1Stream = responseStream
  .map(function(listUsers) {
    // get one random user from the list
    return listUsers[Math.floor(Math.random()*listUsers.length)];
  })
  .merge(
    refreshClickStream.map(function(){ return null; })
  )
  .startWith(null);  
var suggestion1Stream
   .subscribe((response) => {
     if(response === null) {
       //display loading
     } else {
       //display actual value
     }
   })
```

### 4. Implement 'X' button for individual row (reuse latested Stream value)

```javascript
// Essentially we want something like this instead of loading new values every time we click
// stream A: --a-----------e--------i-------->
// stream B: -----b----c--------d-------q---->
//           vvvvvvvv combineLatest(f) vvvvvvv
//           ----AB---AC--EC---ED--ID--IQ---->
//
// where f is the uppercase function
// Stream b is our 'X' button click
var close1Button = document.querySelector('.close1');
var close1ClickStream = Rx.Observable.fromEvent(close1Button, 'click');

var suggestion1Stream = close1ClickStream
 .startWith('startup click') // at the beginning. There is no click yet, but we want to render at the beginning also
 //You pick up the latest value from
 //another Stream (reponseStream), which has already been fetched before during startUp
 .combineLatest(responseStream,             
   function(click, listUsers) {
     // listUsers comes from responseStream
     return listUsers[Math.floor(Math.random()*listUsers.length)];
   }
 )
 .merge(
   refreshClickStream.map(function(){ return null; })
 )
 .startWith(null);
```


### 5. End result
```javascript
// You can see this working example at http://jsfiddle.net/staltz/8jFJH/48/

var refreshButton = document.querySelector('.refresh');
var refreshClickStream = Rx.Observable.fromEvent(refreshButton, 'click');

var closeButton1 = document.querySelector('.close1');
var close1ClickStream = Rx.Observable.fromEvent(closeButton1, 'click');
// and the same logic for close2 and close3

var requestStream = refreshClickStream.startWith('startup click')
  .map(function() {
    var randomOffset = Math.floor(Math.random()*500);
    return 'https://api.github.com/users?since=' + randomOffset;
  });

var responseStream = requestStream
  .flatMap(function (requestUrl) {  //### 2. Notice the flatMap, since we return Observable here
    return Rx.Observable.fromPromise($.ajax({url: requestUrl}));
  });

var suggestion1Stream = close1ClickStream
  .startWith('startup click') // ### 4. Trigger suggestion at the beginning
  .combineLatest(responseStream,             
    function(click, listUsers) {
      return listUsers[Math.floor(Math.random()*listUsers.length)];
    }
  )
  .merge(
    refreshClickStream.map(function(){ return null; }) // ### 3. When we click refresh, display loading
  )
  .startWith(null);  // ### 3. When we start, display loading
// and the same logic for suggestion2Stream and suggestion3Stream

suggestion1Stream.subscribe(function(suggestion) {
  if (suggestion === null) {
    // display loading
  }
  else {
    // show the first suggestion DOM element
    // and render the data
  }
});
```


## When to use RxJS (http://xgrommx.github.io/rx-book/content/guidelines/when/index.html)

### 1. Orchestrate asynchronous and event-based  Computation
```javascript
var input = document.getElementById('input');
var dictionarySuggest = Rx.Observable.fromEvent(input, 'keyup')
  .map(() => input.value)
  .filter(text => !!text) // Ignore blank text
  .distinctUntilChanged() // Ignore left/right arrow that doesn't change text
  .throttle(250)
  .flatMapLatest(searchWikipedia) // If user types a new key, ignore the previous operation. The old search result doesn't matter any more
  .subscribe(
    results => {
      list = [];
      list.concat(results.map(createItem));
    },
    err => logError(err)
  );
```

### 2. Dealing async sequence of data

```javascript
var fs = require('fs');
var Rx = require('rx');

// Read/write from stream implementation 
function readAsync(fd, chunkSize) { /* impl */ }
function appendAsync(fd, buffer) { /* impl */ }
function encrypt(buffer) { /* impl */}

//open a 4GB file for asynchronous reading in blocks of 64K
var inFile = fs.openSync('4GBfile.txt', 'r+');
var outFile = fs.openSync('Encrypted.txt', 'w+');

readAsync(inFile, 2 << 15)
  .map(encrypt)
  .flatMap(data => appendAsync(outFile, data))
  .subscribe(
    () => {},
    err => {
      console.log('An error occurred while encrypting the file: %s', err.message);
      fs.closeSync(inFile);
      fs.closeSync(outFile);
    },
    () => {
      console.log('Successfully encrypted the file.');
      fs.closeSync(inFile);
      fs.closeSync(outFile);
    }
  );
```
