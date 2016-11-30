--=========== Copyright © 2016, Planimeter, All rights reserved. =============--
--
-- Purpose: Extends the base library
--
--============================================================================--

function accessor( class, member, key )
	if ( type( class ) ~= "table" ) then
		typerror( 1, "table", class )
	end

	class[ "set" .. string.capitalize( member ) ] = function( self, value )
		self[ key or member ] = value
	end

	class[ "get" .. string.capitalize( member ) ] = function( self )
		return self[ key or member ]
	end
end

if ( not rawtype ) then
	rawtype = type

	function type( object )
		local mt = getmetatable( object )
		if ( mt ~= nil and rawget( mt, "__type" ) ~= nil ) then
			return rawget( mt, "__type" )
		end

		return rawtype( object )
	end
end

function typeof( object, class )
	if ( type( object ) == class ) then
		return true
	end

	if ( rawtype( object ) == "table" ) then
		local base = getbaseclass( object )
		while ( base ~= nil ) do
			if ( base.__type == class ) then
				return true
			end

			base = getbaseclass( base )
		end
	end

	return rawtype( object ) == class
end

function typerror( narg, tname, value )
	local info = debug.getinfo( 2, "n" )
	error( "bad argument #" .. narg .. " " ..
	       "to '" .. info.name ..
	       "' (" .. tname .. " expected, " ..
	       "got " .. type( value ) .. ")", 3 )
end
