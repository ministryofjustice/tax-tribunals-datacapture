# https://github.com/svenfuchs/i18n/blob/master/lib/i18n/backend/cascade.rb

# By cascading lookups we mean that for any key that can not be found the
# Cascade module strips one segment off the scope part of the key and then
# tries to look up the key in that scope.

# We use cascading to avoid repetition of otherwise identical translation
# between the HTML and PDF versions of the `check your answers` step.

I18n.backend.class.send(:include, I18n::Backend::Cascade)
