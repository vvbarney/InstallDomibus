
# Vytvoriť / stiahnuť

https://ec.europa.eu/digital-building-blocks/sites/spaces/DIGITAL/pages/467110244/Domibus
- Download the default_keystore_files.zip archive, which contains the gateway_keystore.jks and gateway_truststore.jks files.
- Extract both files from the archive and copy them to <domibus.config.location>/conf/domibus/keystores. Make sure to overwrite the existing files in this folder.
- aktualizuj v [AdminConsole/KeyStore](http://localhost:18080/domibus/keystore)  gateway_keystore.jks / test123
- aktualizuj v [AdminConsole/TrustStore](http://localhost:18080/domibus/truststore)  gateway_truststore.jks / test123
- nastav [AdminConsole/Pode](http://localhost:18080/domibus/pmode-current)

https://ec.europa.eu/digital-building-blocks/code/projects/EDELIVERY/repos/domibus/browse/Core/Domibus-MSH-soapui-tests/src/main/soapui?at=EDELIVERY-9719-Fix_domain_schema_check_error_in_the_case_of_Tomcat-Weblogic_single_tenant_cluster
- Priklad konfigurácie PMODE