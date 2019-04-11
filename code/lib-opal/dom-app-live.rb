#!/usr/bin/env opal -Rserver -AE -Ilib -Ilib-opal

require 'opal'
require 'native'

$$.addEventListener(:hashchange) do
  $$[:location].reload
end

case $$[:location][:hash]
when '#0' then require 'dom-app/dom-app 0'
when '#1' then require 'dom-app/dom-app 1'
when '#2' then require 'dom-app/dom-app 2'
when '#3' then require 'dom-app/dom-app 3'
when '#4' then require 'dom-app/dom-app 4'
when '#5' then require 'dom-app/dom-app 5'
when '#6' then require 'dom-app/dom-app 6'
when '#7' then require 'dom-app/dom-app 7'
else require 'playground'
end
