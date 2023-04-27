local npc = {
  position = vector3(-100.0, -1234.56, 67.8),
  name = "Garbage Supervisor",
}

function spawnNPC()
  local ped = CreatePed(4, GetHashKey("a_m_y_business_02"), npc.position, 0.0, true, false)
  SetEntityHeading(ped, 180.0)
  TaskStandStill(ped, -1)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if jobStarted == true then
      spawnNPC()
    end
  end
end)

local talkingToNPC = false

function detectPlayerInRange()
  while true do
    Citizen.Wait(0)

    if jobStarted == true and not talkingToNPC then
      local playerCoords = GetEntityCoords(PlayerPedId())
      local distanceToNPC = #(playerCoords - npc.position)

      if distanceToNPC < 2.0 then
        DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "Press E to talk to " .. npc.name)

        if IsControlJustPressed(0, Keys["E"]) then
          talkingToNPC = true
          TriggerServerEvent("qb-garbagejob:startDialogue", npc.name)
        end
      end
    end
  end
end

function startDialogue(npcName)
  local dialogueStarted = true
  local currentDialogueStepNum = 1

  while dialogueStarted do
    Citizen.Wait(0)

    if currentDialogueStepNum == 1 then
      -- display initial greeting dialogue
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "Hello there! My name is " .. npc.name .. ". How can I help you today?")

      if IsControlJustPressed(0, Keys["E"]) then
        currentDialogueStepNum = 2
      end
    elseif currentDialogueStepNum == 2 then
      -- display response to player input
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "You're here for the garbage collection job, right? It's a dirty job, but someone's got to do it.")

      if IsControlJustPressed(0, Keys["E"]) then
        currentDialogueStepNum = 3
      end
    elseif currentDialogueStepNum == 3 then
      -- display more NPC dialogue options
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "Make sure to collect all the garbage bags you can find. We don't want any litter on our streets. Good luck!")

      if IsControlJustPressed(0, Keys["E"]) then
        currentDialogueStepNum = 4
      end
    elseif currentDialogueStepNum == 4 then
      -- final NPC response
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "I'll be around if you need any help or have any questions. Have a good day!")

      if IsControlJustPressed(0, Keys["E"]) then
        dialogueStarted = false
      end
    end
  end

  talkingToNPC = false
end
