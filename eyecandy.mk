# Reset
RESET:='\e[0m'       # Text Reset

# Regular Colors
BLACK:='\e[0;30m'        # Black
RED:='\e[0;31m'          # Red
GREEN:='\e[0;32m'        # Green
YELLOW:='\e[0;33m'       # Yellow
BLUE:='\e[0;34m'         # Blue
PURPLE:='\e[0;35m'       # Purple
CYAN:='\e[0;36m'         # Cyan
WHITE:='\e[0;37m'        # White

# Bold
BBLACK:='\e[1;30m'       # Black
BRED:='\e[1;31m'         # Red
BGREEN:='\e[1;32m'       # Green
BYELLOW:='\e[1;33m'      # Yellow
BBLUE:='\e[1;34m'        # Blue
BPURPLE:='\e[1;35m'      # Purple
BCYAN:='\e[1;36m'        # Cyan
BWHITE:='\e[1;37m'       # White

# Underline
UBLACK:='\e[4;30m'       # Black
URED:='\e[4;31m'         # Red
UGREEN:='\e[4;32m'       # Green
UYELLOW:='\e[4;33m'      # Yellow
UBLUE:='\e[4;34m'        # Blue
UPURPLE:='\e[4;35m'      # Purple
UCYAN:='\e[4;36m'        # Cyan
UWHITE:='\e[4;37m'       # White

# Background
ON_BLACK:='\e[40m'       # Black
ON_RED:='\e[41m'         # Red
ON_GREEN:='\e[42m'       # Green
ON_YELLOW:='\e[43m'      # Yellow
ON_BLUE:='\e[44m'        # Blue
ON_PURPLE:='\e[45m'      # Purple
ON_CYAN:='\e[46m'        # Cyan
ON_WHITE:='\e[47m'       # White

# High Intensity
IBLACK:='\e[0;90m'       # Black
IRED:='\e[0;91m'         # Red
IGREEN:='\e[0;92m'       # Green
IYELLOW:='\e[0;93m'      # Yellow
IBLUE:='\e[0;94m'        # Blue
IPURPLE:='\e[0;95m'      # Purple
ICYAN:='\e[0;96m'        # Cyan
IWHITE:='\e[0;97m'       # White

# Bold High Intensity
BIBLACK:='\e[1;90m'      # Black
BIRED:='\e[1;91m'        # Red
BIGREEN:='\e[1;92m'      # Green
BIYELLOW:='\e[1;93m'     # Yellow
BIBLUE:='\e[1;94m'       # Blue
BIPURPLE:='\e[1;95m'     # Purple
BICYAN:='\e[1;96m'       # Cyan
BIWHITE:='\e[1;97m'      # White

# High Intensity backgrounds
ON_IBLACK:='\e[0;100m'   # Black
ON_IRED:='\e[0;101m'     # Red
ON_IGREEN:='\e[0;102m'   # Green
ON_IYELLOW:='\e[0;103m'  # Yellow
ON_IBLUE:='\e[0;104m'    # Blue
ON_IPURPLE:='\e[0;105m'  # Purple
ON_ICYAN:='\e[0;106m'    # Cyan
ON_IWHITE:='\e[0;107m'   # White

ECHO :=echo -e 

COMMENT_BZIP2           := 'BZIP2   '
COMMENT_CC              := 'CC      '
COMMENT_CONFIGURE       := 'CONFIGURE   '
COMMENT_GENERATE        := 'GENERATE    '
COMMENT_GZIP            := 'GZIP    '
COMMENT_INSTALL         := 'INSTALL '
COMMENT_LN              := 'LN      '
COMMENT_MAKE            := 'MAKE    '
COMMENT_MKDIR           := 'MKDIR   '
COMMENT_PATCH           := 'PATCH    '
COMMENT_RM              := 'RM  '
COMMENT_UNTAR           := 'TAR '
COMMENT_STRIP           := 'STRIP '

ECHO_BZIP2      :=$(ECHO) $(CYAN)$(COMMENT_BZIP2)$(RESET)
ECHO_CC         :=$(ECHO) $(RED)$(COMMENT_CC)$(RESET)
ECHO_CONFIGURE  :=$(ECHO) $(GREEN)$(COMMENT_CONFIGURE)$(RESET)
ECHO_GENERATE   :=$(ECHO) $(BGREEN)$(COMMENT_GENERATE)$(RESET)
ECHO_GZIP       :=$(ECHO) $(CYAN)$(COMMENT_GZIP)$(RESET)
ECHO_INSTALL    :=$(ECHO) $(YELLOW)$(COMMENT_INSTALL)$(RESET)
ECHO_LN         :=$(ECHO) $(CYAN)$(COMMENT_LN)$(RESET)
ECHO_MAKE       :=$(ECHO) $(BYELLOW)$(COMMENT_MAKE)$(RESET)
ECHO_MKDIR      :=$(ECHO) $(WHITE)$(COMMENT_MKDIR)$(RESET)
ECHO_PATCH      :=$(ECHO) $(BIYELLOW)$(COMMENT_PATCH)$(RESET)
ECHO_RM         :=$(ECHO) $(BWHITE)$(COMMENT_RM)$(RESET)
ECHO_UNTAR      :=$(ECHO) $(CYAN)$(COMMENT_UNTAR)$(RESET)
ECHO_STRIP      :=$(ECHO) $(CYAN)$(COMMENT_STRIP)$(RESET)
