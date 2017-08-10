Date::DATE_FORMATS.merge!(
    :date_picker => '%a %b %-d, %Y',
)
Time::DATE_FORMATS.merge!(
    :date_only => '%Y-%m-%d',
    :fulltime => '%a %b %d %H:%M',
    :datetimepicker => '%a %b %d, %Y %H:%M %p'
)
