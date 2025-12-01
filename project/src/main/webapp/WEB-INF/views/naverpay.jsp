<!DOCTYPE html>
<html>
<head></head>
<body>

<input type="button" id="naverPayBtn" value="네이버페이 결제 버튼">
<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
var oPay = Naver.Pay.create({
     "mode" : "development",
     "clientId": "HN3GGCMDdTgGUfl0kFCo",
     "chainId": "K0pnei9ZMkxZZVp"
});

$("#naverPayBtn").click(function() {
    // 서버에서 merchantPayKey 발급 요청
    $.post("/payment/naver/start", {
        productName: "상품명",
        totalPayAmount: 38000
    }, function(res) {
        if(res.merchantPayKey) {
            oPay.open({
                merchantPayKey: res.merchantPayKey,
                productName: "상품명",
                productCount: "1",
                totalPayAmount: 38000,
                taxScopeAmount: 38000,
                taxExScopeAmount: 0,
                returnUrl: "https://your-domain.com/payment/naver/return"
            });
        } else {
            alert("결제 키 발급 실패");
        }
    });
});
</script>