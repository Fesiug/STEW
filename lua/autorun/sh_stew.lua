
-- STEW is by Fesiug, made in 2023!

CreateConVar( "stew_mod_mgsv", 0, FCVAR_ARCHIVE + FCVAR_REPLICATED )
CreateClientConVar("stew_camera", 0, true, false)

STEW = {}

STEW.Profile = {}

STEW.Profile["556x45"] = {
	near = 35,
	far = 26,
	force = 5,
}

STEW.Profile["545x39"] = {
	near = 34,
	far = 28,
	force = 5,
}

STEW.Profile["762x51"] = {
	near = 42,
	far = 35,
	force = 10,
}

STEW.Profile["762x39"] = {
	near = 35,
	far = 25,
	force = 5,
}

STEW.Profile["45acp"] = {
	near = 35,
	far = 21,
	force = 5,
}

STEW.SoundBank = {}

local sflag = ")"

STEW.SoundBank["blast_556x45"] = {
	sflag .. "weapons/arccw_ud/m16/fire-01.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-02.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-03.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-04.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-05.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-06.ogg",
}

STEW.SoundBank["blast_545x39"] = {
	sflag .. "weapons/arccw_ur/ak/545_39/fire-01.ogg",
	sflag .. "weapons/arccw_ur/ak/545_39/fire-02.ogg",
	sflag .. "weapons/arccw_ur/ak/545_39/fire-03.ogg",
	sflag .. "weapons/arccw_ur/ak/545_39/fire-04.ogg",
	sflag .. "weapons/arccw_ur/ak/545_39/fire-05.ogg",
	sflag .. "weapons/arccw_ur/ak/545_39/fire-06.ogg",
}

STEW.SoundBank["blast_762x51"] = {
	sflag .. "weapons/arccw_ud/m16/fire-01.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-02.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-03.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-04.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-05.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-06.ogg",
}

STEW.SoundBank["blast_762x39"] = {
	sflag .. "weapons/arccw_ur/ak/fire-01.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-02.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-03.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-04.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-05.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-06.ogg",
}

STEW.SoundBank["blast_45acp"] = {
	sflag .. "weapons/arccw_uc_usp/fire-01.ogg",
	sflag .. "weapons/arccw_uc_usp/fire-02.ogg",
	sflag .. "weapons/arccw_uc_usp/fire-03.ogg",
	sflag .. "weapons/arccw_uc_usp/fire-04.ogg",
	sflag .. "weapons/arccw_uc_usp/fire-05.ogg",
	sflag .. "weapons/arccw_uc_usp/fire-06.ogg",
}

STEW.SoundBank["action_ak"] = {
	sflag .. "weapons/arccw_ur/ak/mech-01.ogg",
	sflag .. "weapons/arccw_ur/ak/mech-02.ogg",
	sflag .. "weapons/arccw_ur/ak/mech-03.ogg",
	sflag .. "weapons/arccw_ur/ak/mech-04.ogg",
	sflag .. "weapons/arccw_ur/ak/mech-05.ogg",
	sflag .. "weapons/arccw_ur/ak/mech-06.ogg",
}

STEW.SoundBank["action_ar"] = {
	sflag .. "weapons/arccw_ud/m16/mech-01.ogg",
	sflag .. "weapons/arccw_ud/m16/mech-02.ogg",
	sflag .. "weapons/arccw_ud/m16/mech-03.ogg",
	sflag .. "weapons/arccw_ud/m16/mech-04.ogg",
	sflag .. "weapons/arccw_ud/m16/mech-05.ogg",
	sflag .. "weapons/arccw_ud/m16/mech-06.ogg",
}

STEW.SoundBank["tail_762x39"] = {
	sflag .. "weapons/arccw_ur/ak/fire-dist-01.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-dist-02.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-dist-03.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-dist-04.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-dist-05.ogg",
	sflag .. "weapons/arccw_ur/ak/fire-dist-06.ogg",
}

STEW.SoundBank["tail_556x45"] = {
	sflag .. "weapons/arccw_ud/m16/fire-dist-01.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-dist-02.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-dist-03.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-dist-04.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-dist-05.ogg",
	sflag .. "weapons/arccw_ud/m16/fire-dist-06.ogg",
}

-- 545 actually uses 556 ak sounds
STEW.SoundBank["tail_545x39"] = {
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-01.ogg",
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-02.ogg",
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-03.ogg",
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-04.ogg",
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-05.ogg",
	sflag .. "weapons/arccw_ur/ak/556/fire-dist-06.ogg",
}