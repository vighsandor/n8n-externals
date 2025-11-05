## PDF Signing with open-pdf-sign

Digital signature functionality has been implemented using the open-source "open-pdf-sign" application, which provides a straightforward command-line solution for signing PDF documents in both visible and invisible formats. The tool supports the primary PAdES signature profiles—BASELINE-B, BASELINE-T, BASELINE-LT, and BASELINE-LTA—ensuring full compliance with European Union ETSI standards.

### Sources and Implementation
The "open-pdf-sign" project is freely available at https://www.openpdfsign.org and on GitHub at https://github.com/open-pdf-sign/open-pdf-sign. The project maintains active development with recent releases available at https://github.com/open-pdf-sign/open-pdf-sign/releases/tag/v0.3.0. The critical signing component—org/openpdfsign/dss—is accessible at https://github.com/open-pdf-sign/open-pdf-sign/tree/master/src/main/java/org/openpdfsign/dss. Comprehensive usage instructions and documentation are provided in the project's README at https://github.com/open-pdf-sign/open-pdf-sign/blob/master/README.md.

### ETSI Standard Compliance and DSS Engine
The "open-pdf-sign" implementation fully adheres to European Union ETSI standards, guaranteeing legal and technical compliance for electronic signatures. The application is built upon the DSS signing engine, which implements ETSI eIDAS and PAdES specifications and is itself available as open-source software at https://github.com/esig/dss/.

The tool integrates seamlessly into automated workflows, web servers, and CI/CD pipelines, providing ETSI-compliant digital document authentication across diverse deployment scenarios.

### Signature Validation
The signed PDF files generated can be verified using the official European Union "DSS Demonstration WebApp" platform. The validation functionality is available through the 'Validate Signature' feature at https://ec.europa.eu/digital-building-blocks/DSS/webapp-demo/validation, which allows users to confirm the authenticity and integrity of the digitally signed documents in compliance with ETSI standards.
