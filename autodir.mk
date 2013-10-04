# autodir.mk
# @brief Automatic directory creation
# This one here allows automatic directory creation
# All that is required is the secondary expansion of the prerequisites.
# And all the object files shall also be dependant, 'order only', on their
# containting directories + '/.' suffix.
# @usage
# @attention This one requires the SECONDEXPANSION to be enabled
.PRECIOUS: %/.
%/.:
	@mkdir -p $@
