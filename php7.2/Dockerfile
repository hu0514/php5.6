#base image
FROM centos

#yum install base packages
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install -y gcc gcc-c++ ncurses-devel libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel autoconf pcre-devel libtool-libs freetype-devel gd zlib-devel zip unzip wget  file bison cmake patch mlocate flex diffutils automake make  readline-devel  glibc-devel glibc-static glib2-devel  bzip2-devel gettext-devel libcap-devel logrotate openssl expect mysql-devel vim net-tools \
    && groupadd www \
    && useradd -s /sbin/nologin -g www www \
    && cd /mnt \
    && wget http://code.amysql.com/files/libiconv-1.14.tar.gz -O - | tar -zx \
    && cd libiconv-1.14 \
    && sed -i 's/_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");/\#if defined(__GLIBC__) \&\& !defined(__UCLIBC__) \&\& !__GLIBC_PREREQ(2, 16)\n_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");\n\#endif/g' srclib/stdio.in.h \
    && ./configure --prefix=/usr/local/libiconv \
    && make && make install \
    && cd .. \

    && wget https://nih.at/libzip/libzip-1.2.0.tar.gz -O - |tar -zx \
    && cd libzip-1.2.0 \
    && ./configure \
    && make && make install \
    && cd .. \

    && wget https://www.php.net/distributions/php-7.2.18.tar.gz -O - | tar -zx \
    && cd php-7.2.18 \
    && sed -i 's/\#include <zipconf.h>/\#include <\/usr\/local\/lib\/libzip\/include\/zipconf.h>/g' /usr/local/include/zip.h \
    && ./configure --prefix=/usr/local/php7.2 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-config-file-path=/usr/local/php7.2/etc --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl --with-zlib  --with-curl --enable-ftp --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --enable-gd-native-ttf --enable-mbstring --enable-zip --with-iconv=/usr/local/libiconv  --without-pear --with-gettext --enable-fileinfo \
    && make -j 4 \ 
    && make install \
    && cd .. \
    && mkdir /usr/local/php7.2/var/run/pid \
    && ln -s /usr/local/php7.2/bin/php /usr/bin/php \
    && ln -s /usr/local/php7.2/bin/phpize /usr/bin/phpize \
    && ln -s /usr/local/php7.2/sbin/php-fpm /usr/bin/php-fpm \
    && rm -rf /mnt/* \
    && yum clean all 
#    && ln -sf /dev/stderr /usr/local/php7.2/php-fpm.log
ADD ./files/php-fpm.conf  /home/php7.2/
ADD ./files/php.ini /home/php7.2/
ADD ./files/setup.sh /tmp/
RUN chmod 755 /tmp/setup.sh

# install mongodb support
# http://pecl.php.net/package/mongodb
RUN cd /mnt/ \
    && wget https://pecl.php.net/get/mongodb-1.5.3.tgz \
    && tar zxf mongodb-1.5.3.tgz \
    && cd mongodb-1.5.3 \
    && /usr/local/php7.2/bin/phpize \
    && ./configure --with-php-config=/usr/local/php7.2/bin/php-config \
    && make && make install \
    && cd /mnt/ \
    && rm -rf mongodb-1.5.3.tgz mongodb-1.5.3 package.xml \
    && echo [mongodb] >> /home/php7.2/php.ini \
    && echo extension = mongodb.so >> /home/php7.2/php.ini
ENTRYPOINT ["/tmp/setup.sh"]
#ENTRYPOINT ["/usr/bin/php-fpm","-F"]
#EXPOSE 9000
