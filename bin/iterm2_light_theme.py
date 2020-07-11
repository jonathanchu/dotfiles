#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import iterm2

async def main(connection):
    # Get the color preset we'd like
    preset = await iterm2.ColorPreset.async_get(connection, "One Light")
    profiles = await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        # Fetch the full profile and then set the color preset in it
        profile = await partial.async_get_full_profile()
        await profile.async_set_color_preset(preset)

iterm2.run_until_complete(main)
