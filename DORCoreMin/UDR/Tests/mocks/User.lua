function newUserMock(isHost) 
	return { 
		isHost = function ()
			return isHost
		end
	}
end