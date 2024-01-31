# Edge Rate Limiting Test Service

This Terraform code can be used to deploy and test various Edge Rate Limiting (ERL) rules at Fastly.

## Running Load Tests

Here are some examples of running load tests against this service:

```
echo "POST https://dmichael-erl-testing.global.ssl.fastly.net/v1/auth/token/external/loginSOMETHING" | vegeta attack -duration=5s -rate=5 | vegeta report --type=text
```

```
echo "POST https://dmichael-erl-testing.global.ssl.fastly.net/v1/auth/token/external/loginSOMETHING" | vegeta attack -rate=50 -duration=10s | tee results.bin | vegeta report
vegeta report -type=json results.bin > metrics.json
cat results.bin | vegeta plot > plot.html
cat results.bin | vegeta report -type="hist[0,100ms,200ms,300ms]"
```