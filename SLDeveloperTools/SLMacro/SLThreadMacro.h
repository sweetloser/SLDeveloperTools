//
//  SLThreadMacro.h
//  Pods
//
//  Created by sweetloser on 2021/11/15.
//

#ifndef SLThreadMacro_h
#define SLThreadMacro_h

#ifndef sl_dispatch_main_async_safe
#define sl_dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#endif /* SLThreadMacro_h */
