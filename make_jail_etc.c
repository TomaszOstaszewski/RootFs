/*!
 * \mainpage The <tt>use_crypt</tt>application.
 *
 * \section intro_sec Introduction
 *
 * This is the introduction.
 *
 * \section install_sec Usage
 * Lorem ipsum...
 * \subsection generate_shadow Generate the /etc/shadow entry.
 * Lorem ipsum...
 * \subsection generate_shadow Generate the /etc/passwd entry.
 * Lorem ipsum...
 * \subsection generate_shadow Generate the /etc/group entry.
 *
 */

/*!
 * \page page1 A documentation page
 * Lorem ipsum
 * \tableofcontents
 * Lorem ipsum
 * Leading text.
 * \section sec An example section
 * This page contains the subsections \ref subsection1 and \ref subsection2.
 * For more info see page \ref page2.
 * \subsection subsection1 The first subsection
 * Text.
 * \subsection subsection2 The second subsection
 * More text.
 */

/*! 
 * \page page2 Another page
 * Even more info.
 */

/*!
 * @brief Generator for chroot-jail files.
 * @details
 * @author T.Ostaszewski
 * @date Dec-2012
 * @file use_crypt.c 
 */
#include <crypt.h>
#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

/*!
 * @brief Defines what kind of output to generate.
 */
typedef enum use_crypt_output_kind {
	OUTPUT_ETC_PASSWD = 1, /*!< Generate the entries for <tt>/etc/passwd</tt> file.*/
	OUTPUT_ETC_SHADOW, /*!< Generate the entries for <tt>/etc/shadow</tt> file.*/
	OUTPUT_ETC_GROUP,  /*!< Generate the entries for <tt>/etc/group</tt> file.*/
} use_crypt_output_kind_t;

/*!
 * @brief Defines settings for the program run.
 * @details This structure defines the parameters that tell the program:
 * <ul>
 * <li>what kind of output to generate</li>
 * <li>what are the parameters for this output</li>
 * </ul>
 */
typedef struct use_crypt_run_arguments {
	use_crypt_output_kind_t output_kind_; /*!< What kind of file to generate.*/
	const char * output_file_name_; /*!< Pointer to the string that tells what is the output file name. */
 	/*!
 	 * @brief Pointer to the string that tells what is the user name. 
	 * @attention The same string is reused as group name in the <tt>/etc/group</tt> file. 
	 */
	const char * user_and_group_name_;
	const char * user_home_dir_;
	const char * user_shell_; /*!< User shell, i.e. <tt>/bin/sh</tt> */
	const char * password_; /*!< Pointer to the string that tells what is the user password. */
	int user_group_id_; /*!< A numerical id for the user or the group */
} use_crypt_run_arguments_t;

/*!
 * @brief Global variable to store program runtime settings. 
 */
static use_crypt_run_arguments_t g_run_arguments;

static void die(const char * format, ...) 
{
    va_list arg_list;
    va_start(arg_list, format);
    vfprintf(stderr, format, arg_list);
    va_end(arg_list); 
    exit(EXIT_FAILURE);
}

static void usage(char ** argv)
{
	fprintf(stderr, "Usage: \n"
		"%s [-P | -S | -G ] -p <passwd> -u <user name> -s <shell to use> [ -o <file_name> ]\n",
		argv[0]		
	);
}

static FILE * get_output_file_stream(const char * output_name)
{
	if (NULL == output_name)
		return stdout;
	return fopen(output_name, "w+");
}

/*!
 * @brief Validate input arguments.
 * @details Validation rules are as follows:
 * for output a jail's <tt>/etc/shadow</tt> file:
 * <ul>
 * <li>the user name cannot be null</li>
 * <li>the password cannot be null</li>
 * </ul>
 * for output a jail's <tt>/etc/passwd</tt> file:
 * <ul>
 * <li>the user name cannot be null</li>
 * </ul>
 * for output a group file:
 * <ul>
 * <li>the group name cannot be null</li>
 * </ul>
 * @param[in]
 * @return
 */
static int validate_input_args(use_crypt_run_arguments_t const * p_args)
{
	int retVal = 0;
	switch (p_args->output_kind_)
	{
		case OUTPUT_ETC_SHADOW:
			if (NULL == p_args->user_and_group_name_)
			{
				fprintf(stderr, "user name not given.\n");
				retVal = 1;
			}
			else if (NULL == p_args->password_)
			{
				fprintf(stderr, "password name not given.\n");
				retVal = 1;
			}
			else
			{
				;
			}
			break;
		case OUTPUT_ETC_PASSWD:
			if (NULL == p_args->user_and_group_name_)
			{
				fprintf(stderr, "User and group name not given.\n" );
				retVal = 1;
			}
			else if (NULL == p_args->user_shell_)
			{
				fprintf(stderr, "User shell not given.\n" );
				retVal = 1;
			}
			else
				;
			break;
		case OUTPUT_ETC_GROUP:
			if (NULL == p_args->user_and_group_name_)
			{
				fprintf(stderr, "%4.4u Group name not given.\n", __LINE__);
				retVal = 1;
			}
			else
				;
			break;
		default:
			retVal = 1;
			fprintf(stderr, "%4.4u %s\n", __LINE__, __func__);
			break;
	}
	return retVal;
}

/*!
 * @brief Generate entry for /etc/shadow file:
 * As per manpage:
 * /etc/passwd contains one line for each user account, with seven fields delimited by colons (":"). 
 * These fields are:
 * <ul>
 * <li>login name</li>
 * <li>optional encrypted password</li>
 * <li>numerical user ID</li>
 * <li>numerical group ID</li>
 * <li>user name or comment field</li>
 * <li>user home directory</li>
 * <li>optional user command interpreter</li>
 * </ul>
 * @details
 * @param[in]
 * @return
 */
static int generate_etc_passwd(use_crypt_run_arguments_t const * p_args)
{
	int retVal = 0;
	FILE * fstream = get_output_file_stream(p_args->output_file_name_);
	if (NULL != fstream)
	{
		fprintf(get_output_file_stream(p_args->output_file_name_), "%s:x:%d:%d::%s/:%s\n", 
				p_args->user_and_group_name_, 
				p_args->user_group_id_,
				p_args->user_group_id_,
				p_args->user_home_dir_,
				p_args->user_shell_
			   );
	}
	else
	{
		retVal = -1;
	}
	return retVal;
}

/*!
 * @brief Generates contents for the shadow file.
 * @param[in] p_args
 * @return
 */
static int generate_etc_shadow(use_crypt_run_arguments_t const * p_args)
{
	int retVal = 0;
	int i;
	unsigned long seed[2];
	char salt[] = "$5$........";
	const char *const seedchars =
		"./0123456789ABCDEFGHIJKLMNOPQRST"
		"UVWXYZabcdefghijklmnopqrstuvwxyz";
	char *password;
	/* Generate a (not very) random seed.
	 *           You should do it better than this... */
	seed[0] = time(NULL);
	seed[1] = getpid() ^ (seed[0] >> 14 & 0x30000);

	/* Turn it into printable characters from `seedchars'. */
	for (i = 0; i < 8; i++)
		salt[3+i] = seedchars[(seed[i/5] >> (i%5)*6) & 0x3f];

	/* Read in the user's password and encrypt it. */
	password = crypt(p_args->password_, salt);

	/* Print the results. */
	FILE * output_stream = get_output_file_stream(p_args->output_file_name_);
	if (NULL != output_stream)
	{
		fprintf(get_output_file_stream(p_args->output_file_name_), 
			"%s:%s:::::::\n", p_args->user_and_group_name_, password);
	}
	else
	{
		fprintf(stderr, "Could not open output file %s, error %d", p_args->output_file_name_, errno);	
		retVal = -1;
	}
	return retVal;
}

/*!
 * @brief Generate the entry for the /etc/group file
 * @details
 * @param[in]
 * @return
 */
static int generate_etc_group(use_crypt_run_arguments_t const * p_args)
{
	/* Print the results. */
	fprintf(get_output_file_stream(p_args->output_file_name_), "%s:x:%d:\n", p_args->user_and_group_name_, p_args->user_group_id_);
	return 0;
}

static int parse_input_args(int argc, char ** argv, use_crypt_run_arguments_t * p_args)
{
	int c;
	opterr = 0;

	while ((c = getopt (argc, argv, "HPSGp:o:u:i:s:h:")) != -1)
	{
		switch (c)
		{
			case 'H':
				usage(argv);
				exit(EXIT_SUCCESS);
				break;
			case 'P':
				g_run_arguments.output_kind_ = OUTPUT_ETC_PASSWD;
				break;
			case 'S':
				g_run_arguments.output_kind_ = OUTPUT_ETC_SHADOW;
				break;
			case 'G':
				g_run_arguments.output_kind_ = OUTPUT_ETC_GROUP;
				break;
			case 'p':
				g_run_arguments.password_ = optarg;
				break;
			case 'o':
				g_run_arguments.output_file_name_ = optarg;
				break;
			case 's':
				g_run_arguments.user_shell_ = optarg;
				break;
			case 'u':
				g_run_arguments.user_and_group_name_ = optarg;
				break;
			case 'h':
				g_run_arguments.user_home_dir_ = optarg;
				break;
			case 'i':
				{
					int scanf_result = sscanf(optarg, "%d", &g_run_arguments.user_group_id_);
					if (1 != scanf_result)
					{
						fprintf (stderr, "Option -%c requires a decimal numeric argument.\n", optopt);
						return -1;
					}
				}
				break;
			case '?':
				if (optopt == 'o')
					fprintf (stderr, "Option -%c requires an argument.\n", optopt);
				else if (isprint (optopt))
					fprintf (stderr, "Unknown option `-%c'.\n", optopt);
				else
					fprintf (stderr,
							"Unknown option character `\\x%x'.\n",
							optopt);
				return -1;
			default:
				return -1;
		}
	}
	return 0;
}

/*!
 * @brief Program entry point
 */
int main(int argc, char ** argv)
{
    if (0 != parse_input_args(argc, argv, &g_run_arguments))
        die("%4.4u %s\n", __LINE__, __func__);
    if (0 != validate_input_args(&g_run_arguments))
        die("%4.4u %s\n", __LINE__, __func__);
    /* Print the results. */
    switch (g_run_arguments.output_kind_)
    {
        case OUTPUT_ETC_SHADOW:
            generate_etc_shadow(&g_run_arguments);
            break;
        case OUTPUT_ETC_PASSWD:
            generate_etc_passwd(&g_run_arguments);
            break;
        case OUTPUT_ETC_GROUP:
            generate_etc_group(&g_run_arguments);
            break;
        default:
            die("%4.4u %s\n", __LINE__, __func__);
            break;
    }
    return 0;
}

