void dispose(){
    newIsolate?.kill(priority: Isolate.immediate);
    newIsolate = null;
}
