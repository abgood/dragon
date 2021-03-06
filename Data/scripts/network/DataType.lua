

KBEngineLua.DATATYPE_UINT8 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadByte();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeUint8(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
        end

		if(v < 0 or v > 0xff) then
			return false;
		end

		return true;
	end
}

KBEngineLua.DATATYPE_UINT16 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadUShort();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeUint16(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
		end

		if(v < 0 or v > 0xffff) then
			return false;
		end
		return true;
	end
}

KBEngineLua.DATATYPE_UINT32 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadUInt();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeUint32(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
		end

		if(v < 0 or v > 0xffffffff) then
			return false;
		end

		return true;
	end,
}

KBEngineLua.DATATYPE_UINT64 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadUInt64();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeUint64(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return true;
	end
}

KBEngineLua.DATATYPE_INT8 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadByte();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeInt8(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		if(type(v) ~= "number")then
			return false;
		end

		if(v < -0x80 or v > 0x7f)then
			return false;
		end
		return true;
	end
}

KBEngineLua.DATATYPE_INT16 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadShort();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeInt16(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		if(type(v) ~= "number")then
			return false;
		end

		if(v < -0x8000 or v > 0x7fff)then
			return false;
		end
		return true;
	end
}

KBEngineLua.DATATYPE_INT32 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadInt();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeInt32(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)

		if(type(v) ~= "number")then
			return false;
		end

		if(v < -0x80000000 or v > 0x7fffffff)then
			return false;
		end
		return true;
	end
}

KBEngineLua.DATATYPE_INT64 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadInt64();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeInt64(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return true;
	end
}

KBEngineLua.DATATYPE_FLOAT =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadFloat();
	end,

	addToStream = function(self, bundle, v)
		bundle:WriteFloat(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return type(v) == "number";
	end
}

KBEngineLua.DATATYPE_DOUBLE =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadDouble();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeDouble(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return type(v) == "number";
	end
}

KBEngineLua.DATATYPE_STRING =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return stream:ReadString();
	end,

	addToStream = function(self, bundle, v)
		bundle:writeString(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return type(v) == "string";
	end
}

KBEngineLua.DATATYPE_VECTOR2 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return Vector2(stream:ReadFloat(), stream:ReadFloat());
	end,

	addToStream = function(self, bundle, v)
		bundle:writeFloat(v.x);
		bundle:writeFloat(v.y);
	end,

	parseDefaultValStr = function(self, v)
		return Vector2(0,0);
	end,

	isSameType = function(self, v)		
		return true;
	end
}
KBEngineLua.DATATYPE_VECTOR3 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return Vector3(stream:ReadFloat(), stream:ReadFloat(), stream:ReadFloat());
	end,

	addToStream = function(self, bundle, v)
		bundle:writeFloat(v.x);
		bundle:writeFloat(v.y);
		bundle:writeFloat(v.z);
	end,

	parseDefaultValStr = function(self, v)
		return Vector3(0,0,0);
	end,

	isSameType = function(self, v)		
		return true;
	end
}

KBEngineLua.DATATYPE_VECTOR4 =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return Vector4(stream:ReadFloat(), stream:ReadFloat(), stream:ReadFloat(), stream:ReadFloat());
	end,

	addToStream = function(self, bundle, v)
		bundle:writeFloat(v.x);
		bundle:writeFloat(v.y);
		bundle:writeFloat(v.z);
		bundle:writeFloat(v.w);
	end,

	parseDefaultValStr = function(self, v)
		return Vector4(0,0,0,0);
	end,

	isSameType = function(self, v)		
		return true;
	end
}


KBEngineLua.DATATYPE_PYTHON =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return KBEngineLua.readBlob(stream);
	end,

	addToStream = function(self, bundle, v)
		bundle:writeBlob(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v)
	end,

	isSameType = function(self, v)
		return true;
	end
}

KBEngineLua.DATATYPE_UNICODE =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return KBEngineLua.readBlob(stream);
	end,

	addToStream = function(self, bundle, v)
		bundle:writeBlob(v);
	end,

	parseDefaultValStr = function(self, v)
		if(type(v) == "string")then
			return v;
        end
		return "";
	end,

	isSameType = function(self, v)
		return type(v) == "string";
	end
}

KBEngineLua.DATATYPE_ENTITYCALL =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
	end,

	addToStream = function(self, bundle, v)
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return false;
	end
}

KBEngineLua.DATATYPE_BLOB =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return KBEngineLua.readBlob(stream);
	end,

	addToStream = function(self, bundle, v)
		bundle:writeBlob(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,

	isSameType = function(self, v)
		return true;
	end
}

---当做类来使用
KBEngineLua.DATATYPE_ARRAY = { _type = nil };
KBEngineLua.DATATYPE_ARRAY.__index = KBEngineLua.DATATYPE_ARRAY;
KBEngineLua.DATATYPE_ARRAY.New = function(self)
	local me = {};    --初始化self，如果没有这句，那么类所建立的对象改变，其他对象都会改变
    setmetatable(me, KBEngineLua.DATATYPE_ARRAY);  --将self的元表设定为Class
	me._type = nil;
    return me;
end

KBEngineLua.DATATYPE_ARRAY.bind = function(self)
	if(type(self._type) == "number") then
		self._type = KBEngineLua.datatypes[self._type];
	end
end

KBEngineLua.DATATYPE_ARRAY.createFromStream = function(self, stream)
	local size = stream:ReadUInt();
	local datas = {};
	while(size > 0)
	do
		size = size-1;
		table.insert(datas, self._type:createFromStream(stream));
	end
	return datas;
end

KBEngineLua.DATATYPE_ARRAY.addToStream = function(self, bundle, v)
	stream:writeUint32(#v);
	for k,va in pairs(v)
	do
		self._type:addToStream(bundle, va);
	end
end

KBEngineLua.DATATYPE_ARRAY.parseDefaultValStr = function(self, v)
	return loadstring("return "..v);
end

KBEngineLua.DATATYPE_ARRAY.isSameType = function(self, v)
	for k,va in pairs(v)
	do
		if(not self._type:isSameType(va)) then
			return false;
		end
	end
	return true;
end


KBEngineLua.DATATYPE_FIXED_DICT = {dicttype = {}, dictKeys = {}, implementedBy = nil};
KBEngineLua.DATATYPE_FIXED_DICT.__index = KBEngineLua.DATATYPE_FIXED_DICT;

KBEngineLua.DATATYPE_FIXED_DICT.New = function(self)
	local me = {};
	setmetatable(me, KBEngineLua.DATATYPE_FIXED_DICT);
	me.dicttype = {};
	me.dictKeys = {};
	me.implementedBy = nil;
	return me;
end

KBEngineLua.DATATYPE_FIXED_DICT.bind = function(self)
	for itemkey, utype in pairs(self.dicttype) do
		if(type(utype) == "number") then
			self.dicttype[itemkey] = KBEngineLua.datatypes[utype];
		end
	end
end

KBEngineLua.DATATYPE_FIXED_DICT.createFromStream = function(self, stream)
	local datas = {};
	for i, key in ipairs(self.dictKeys) do
		datas[key] = self.dicttype[key]:createFromStream(stream);
	end

	return datas;
end

KBEngineLua.DATATYPE_FIXED_DICT.addToStream = function(self, bundle, v)
	for i, key in ipairs(self.dictKeys) do
		self.dicttype[key]:addToStream(bundle, v[key]);
	end
end

KBEngineLua.DATATYPE_FIXED_DICT.parseDefaultValStr = function(self, v)
	return loadstring("return "..v);
end

KBEngineLua.DATATYPE_FIXED_DICT.isSameType = function(self, v)
	for itemkey,utype in pairs(self.dicttype) do
		if(not utype:isSameType(v[itemkey])) then
			return false;
		end
	end
	return true;
end


KBEngineLua.datatypes = {};
KBEngineLua.datatype2id = {};


KBEngineLua.datatypes["UINT8"]		= KBEngineLua.DATATYPE_UINT8;
KBEngineLua.datatypes["UINT16"]	= KBEngineLua.DATATYPE_UINT16;
KBEngineLua.datatypes["UINT32"]	= KBEngineLua.DATATYPE_UINT32;
KBEngineLua.datatypes["UINT64"]	= KBEngineLua.DATATYPE_UINT64;

KBEngineLua.datatypes["INT8"]		= KBEngineLua.DATATYPE_INT8;
KBEngineLua.datatypes["INT16"]		= KBEngineLua.DATATYPE_INT16;
KBEngineLua.datatypes["INT32"]		= KBEngineLua.DATATYPE_INT32;
KBEngineLua.datatypes["INT64"]		= KBEngineLua.DATATYPE_INT64;

KBEngineLua.datatypes["FLOAT"]		= KBEngineLua.DATATYPE_FLOAT;
KBEngineLua.datatypes["DOUBLE"]	= KBEngineLua.DATATYPE_DOUBLE;

KBEngineLua.datatypes["STRING"]	= KBEngineLua.DATATYPE_STRING;
KBEngineLua.datatypes["VECTOR2"]	= KBEngineLua.DATATYPE_VECTOR2;
KBEngineLua.datatypes["VECTOR3"]	= KBEngineLua.DATATYPE_VECTOR3;
KBEngineLua.datatypes["VECTOR4"]	= KBEngineLua.DATATYPE_VECTOR4;
KBEngineLua.datatypes["PYTHON"]	= KBEngineLua.DATATYPE_PYTHON;
KBEngineLua.datatypes["UNICODE"]	= KBEngineLua.DATATYPE_UNICODE;
KBEngineLua.datatypes["ENTITYCALL"]	= KBEngineLua.DATATYPE_ENTITYCALL;
KBEngineLua.datatypes["BLOB"]		= KBEngineLua.DATATYPE_BLOB;

KBEngineLua.reset_login_datatypes = function()

	KBEngineLua.datatypes[1] = KBEngineLua.datatypes["STRING"];
	KBEngineLua.datatypes[2] = KBEngineLua.datatypes["UINT8"];
	KBEngineLua.datatypes[3] = KBEngineLua.datatypes["UINT16"];
	KBEngineLua.datatypes[4] = KBEngineLua.datatypes["UINT32"];
	KBEngineLua.datatypes[5] = KBEngineLua.datatypes["UINT64"];
	KBEngineLua.datatypes[6] = KBEngineLua.datatypes["INT8"];
	KBEngineLua.datatypes[7] = KBEngineLua.datatypes["INT16"];
	KBEngineLua.datatypes[8] = KBEngineLua.datatypes["INT32"];
	KBEngineLua.datatypes[9] = KBEngineLua.datatypes["INT64"];
	KBEngineLua.datatypes[10] = KBEngineLua.datatypes["PYTHON"];
	KBEngineLua.datatypes[11] = KBEngineLua.datatypes["BLOB"];
	KBEngineLua.datatypes[12] = KBEngineLua.datatypes["UNICODE"];
	KBEngineLua.datatypes[13] = KBEngineLua.datatypes["FLOAT"];
	KBEngineLua.datatypes[14] = KBEngineLua.datatypes["DOUBLE"];
	KBEngineLua.datatypes[15] = KBEngineLua.datatypes["VECTOR2"];
	KBEngineLua.datatypes[16] = KBEngineLua.datatypes["VECTOR3"];
	KBEngineLua.datatypes[17] = KBEngineLua.datatypes["VECTOR4"];

end
