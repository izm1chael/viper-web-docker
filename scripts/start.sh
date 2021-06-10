#!/bin/sh
# Set Storage Location
sed -i "/storage_path\ =/c storage_path\ =\ "/var/malware"" /root/.viper/viper.conf 

# Pass Argument for db connection
sed -i "/connection\ =/c connection\ =\ "${db_connection}"" /root/.viper/viper.conf

# Pass Argument for log file location
sed -i "/log_file\ =/c log_file\ =\ "${log_file}"" /root/.viper/viper.conf

# Pass Arguments for Web UI
sed -i "/#admin_username\ =/c admin_username\ =\ "${username}"" /root/.viper/viper.conf
sed -i "/#admin_password\ =/c admin_password\ =\ "${password}"" /root/.viper/viper.conf
sed -i "/port\ =/c port\ =\ "${port}"" /root/.viper/viper.conf
sed -i "/host\ =/c host\ =\ "${host}"" /root/.viper/viper.conf

# Pass Arguments for Virustotal
sed -i "/virustotal_has_private_key\ =/c virustotal_has_private_key\ =\ "${virustotal_private}"" /root/.viper/viper.conf
sed -i "/virustotal_has_intel_key\ =/c virustotal_has_intel_key\ =\ "${virustotal_intel}"" /root/.viper/viper.conf
sed -i "/virustotal_key/c virustotal_key\ =\ "${virustotal_key}"" /root/.viper/viper.conf

# Pass Arguments for Cuckoo
sed -i "/cuckoo_modified/c cuckoo_modified\ =\ "${cuckoo_modified}"" /root/.viper/viper.conf
sed -i "/cuckoo_host/c cuckoo_host\ =\ "${cuckoo_host}"" /root/.viper/viper.conf
sed -i "/cuckoo_web/c cuckoo_web\ =\ "${cuckoo_web}"" /root/.viper/viper.conf
sed -i "/auth_token/c auth_token\ =\ "${auth_token}"" /root/.viper/viper.conf


cd /opt/viper-web && \
./viper-web