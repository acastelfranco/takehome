override_dh_auto_build:
	CFLAGS="$(CFLAGS) $(CPPFLAGS)" \
	LDFLAGS="$(shell dpkg-buildflags --get LDFLAGS \
	| sed -e 's/-Wl,-Bsymbolic-functions//') \
	dh_auto_build
