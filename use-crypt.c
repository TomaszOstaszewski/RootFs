/*!
 * @file use-crypt.c 
 * @brief Generator for /etc/shadow file
 * @details 
 */
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <crypt.h>

typedef struct crypt_generator_options {
    int is_date_of_last_password_change_;
    int is_min_password_age_;
    int is_max_password_age_;
    int is_password_warning_;
    int is_password_inactivity_;
    int is_account_expiration_date_;
    const char * login_name_;
    const char * encrypted_password_;
    unsigned int last_password_change_date_;
    unsigned int min_password_age_;
    unsigned int max_password_age_;
    unsigned int password_warning_period_;
    unsigned int password_inactivity_period_;
    unsigned int account_expiration_date_;
} crypt_generator_options_t;

const char * crypt_get_user_name(crypt_generator_options_t const * p_options)
{
    return ":";
}

const char * crypt_get_user_password(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_last_password_change(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_min_password_age(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_max_password_age(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_password_warn_period(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_password_inactivity_period(crypt_generator_options_t const  * p_options)
{
    return ":";
}

const char * crypt_get_password_account_expiration_date(crypt_generator_options_t const  * p_options)
{
    return ":";
}

int get_shadow_line(crypt_generator_options_t const * p_options, char * buffer, size_t buffer_size)
{
    snprintf(buffer, buffer_size, 
            "%s%s%s%s"
            "%s%s%s%s"
            ,
        crypt_get_user_name(p_options),
        crypt_get_user_password(p_options),
        crypt_get_last_password_change(p_options), 
        crypt_get_min_password_age(p_options),
        crypt_get_max_password_age(p_options),
        crypt_get_password_warn_period(p_options),
        crypt_get_password_inactivity_period(p_options),
        crypt_get_password_account_expiration_date(p_options)
        );
    return 0;
}

int main(int argc, char ** argv)
{
	unsigned long seed[2];
	char salt[] = "$5$........";
	const char *const seedchars =
		"./0123456789ABCDEFGHIJKLMNOPQRST"
		"UVWXYZabcdefghijklmnopqrstuvwxyz";
	char *password;
	int i;
	if (argc != 3)
	{
		fprintf(stderr, "%s %d : Invalid number of input arguments.\n", __func__, __LINE__);
		exit(EXIT_FAILURE);
	}
	/* Generate a (not very) random seed.
	 *           You should do it better than this... */
	seed[0] = time(NULL);
	seed[1] = getpid() ^ (seed[0] >> 14 & 0x30000);

	/* Turn it into printable characters from `seedchars'. */
	for (i = 0; i < 8; i++)
		salt[3+i] = seedchars[(seed[i/5] >> (i%5)*6) & 0x3f];

	/* Read in the user's password and encrypt it. */
	password = crypt(argv[2], salt);

	/* Print the results. */
	fprintf(stdout, "%s:%s:::::::\n", argv[2], password);
	return 0;
}
