-- Import the necessary darktable modules
local dt = require "darktable"
local du = require "darktable.utils"

-- This function sorts the images within the group by their import timestamp
local function set_leader_based_on_import_timestamp(group)
    -- Get all the images in the group
    local images = group:get_images()
    
    -- If the group has no images, return
    if #images == 0 then
        return
    end

    -- Sort images by import timestamp (latest timestamp first)
    table.sort(images, function(a, b)
        local a_timestamp = a.import_time or 0
        local b_timestamp = b.import_time or 0
        return a_timestamp > b_timestamp
    end)

    -- Set the first image in the sorted list as the leader
    local leader = images[1]
    group:set_leader(leader)
    
    -- Print a message for confirmation
    dt.print("Group leader set to image with the latest import timestamp: " .. leader.filename)
end

-- This function is triggered when a new image is added or when Darktable starts
local function update_group_leader()
    -- Iterate through all the groups in the library
    local groups = dt.groups.groups
    
    for _, group in ipairs(groups) do
        set_leader_based_on_import_timestamp(group)
    end
end

-- Trigger the update when Darktable starts up
dt.register_event("update_group_leader", update_group_leader)
