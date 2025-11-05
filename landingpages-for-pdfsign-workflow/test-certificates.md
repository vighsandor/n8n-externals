## Testing PDF Signatures with Codegic Free Certificates

For testing the workflow, we recommend using free X.509 digital certificates available from Codegic at https://www.codegic.com/free-x-509-digital-certificates/. These certificates provide a practical solution for development and testing environments without requiring commercial certificate investments.

### Free Certificate Availability
Codegic offers free X.509-based digital certificates valid for 60 days, making them ideal for testing and proof-of-concept implementations. To obtain a test certificate, users need to create a free account on the Codegic platform and request the appropriate certificate type for their testing requirements. This 60-day trial period allows developers to thoroughly evaluate the signing functionality and integration before deploying production-grade solutions.

### Available Certificate Types
Codegic provides several certificate types suitable for different testing scenarios. For this workflow, use the:

- **Document Signing Certificate**: Specifically designed for digitally signing documents such as PDF, Word, Excel, and PowerPoint files—directly applicable to PDF signing workflows

### PKI Integration Benefits
According to Codegic's documentation, all digital certificates issued by Codegic are part of a proper Public Key Infrastructure (PKI) ecosystem, with all certificates chaining back to the Codegic Root CA G2. This ensures that test certificates maintain proper cryptographic standards and can be used to validate that the entire signing workflow functions correctly within a standards-compliant framework.
