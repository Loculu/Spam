---
env:
  contexts:
    - name: context 1
      urls:
        - http://pe.he.rich
  parameters:
    failOnError: true
    failOnWarning: false
    progressToStdout: true

jobs:
  - type: addOns
    parameters:
      updateAddOns: true
    install:
      - ascanrules
      - ascanrulesAlpha
      - ascanrulesBeta
      - pscanrules
      - pscanrulesAlpha
      - pscanrulesBeta
      - domxss
      - graphql
      - soap
      - openapi
      - spiderAjax
      - reports
      - automation

  - type: passiveScan-config
    parameters:
      scanOnlyInScope: true
      maxAlertsPerRule: 10

  - type: spider
    parameters:
      context: context 1
      url: http://pe.he.rich
      maxDuration: 10
      postForm: true
      processForm: true
      threadCount: 4

  - type: spiderAjax
    parameters:
      context: context 1
      url: http://pe.he.rich
      maxDuration: 10

  - type: passiveScan-wait
    parameters:
      maxDuration: 5

  - type: activeScan
    parameters:
      context: context 1
      delayInMs: 100
      handleAntiCSRFTokens: true
      maxRuleDurationInMins: 5
      maxScanDurationInMins: 15
      policyDefinition:
        defaultStrength: Insane
        defaultThreshold: Medium

  - type: report
    parameters:
      template: traditional-html
      reportDir: /zap/reports
      reportFile: zap-report.html
      reportTitle: "ZAP Scan Report"
      reportDescription: "Automatisierter Full Scan von pe.he.rich"
      displayReport: false
    risks:
      - high
      - medium
      - low
      - info
    confidences:
      - high
      - medium
      - low
      - falsepositive

docker run --rm -v /opt/zap/:/zap/wrk -v ./report:/zap/reports zaproxy/zap-weekly zap.sh -cmd -autorun /zap/wrk/zap.yaml
