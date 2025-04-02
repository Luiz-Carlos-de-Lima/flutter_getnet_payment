# 1.0.0
* First release of the plugin.

* Features: Payment, refund, pre-authorization, custom printing, last receipt reprint, and device information.

# 1.0.1

* fix static analysis errors

# 1.0.2

* removing unused dependencies

# 1.1.0

* rename files and class

# 1.1.1
* add get device info

# 1.1.2
* fix bug returning pending transactions

# 1.1.3
* fix bug deeplink access statusDeeplink

# 1.1.4
* fix optional parameters of GetStatusPaymentResponse

# 1.1.5
* add ignore break lines in GetnetContentPrint

# 1.1.6
* fixed attribute data 'refunded' from 'GetnetStatusPaymentResponse' is String, added cast to bool

# 1.1.7
* fixed inputType attribute is null in 'GetnetStatusPaymentResponse' when payment is of type 'PIX'