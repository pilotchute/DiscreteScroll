#import <ApplicationServices/ApplicationServices.h>
#define lines 4
#define sign(delta) ((delta < 0) - (delta > 0))

CGEventRef cgEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (!CGEventGetIntegerValueField(event, kCGScrollWheelEventIsContinuous)) {
        int64_t delta = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1);
        CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1, sign(delta) * lines);
    }
    return event;
}

int main(void) {
    CFMachPortRef eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, CGEventMaskBit(kCGEventScrollWheel), cgEventCallback, NULL);
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);
    CFRunLoopRun();
    CFRelease(eventTap);
    CFRelease(runLoopSource);
    return 0;
}
