#import <ApplicationServices/ApplicationServices.h>

#define SIGN(x) ((x < 0) - (x > 0))
#define LINES 4

CGEventRef cgEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    if (!CGEventGetIntegerValueField(event, kCGScrollWheelEventIsContinuous)) {
        int64_t delta = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1);
        CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1, SIGN(delta) * LINES);
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
