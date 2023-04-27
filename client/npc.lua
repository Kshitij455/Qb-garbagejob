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
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "Hello there! How can I assist you today?")

      if IsControlJustPressed(0, Keys["E"]) then
        currentDialogueStepNum = 2
      end
    elseif currentDialogueStepNum == 2 then
      -- display response to player input
      DrawText3D(npc.position.x, npc.position.y, npc.position.z + 1.0, "Ah, I see. Well, let me know if you need any help!")

      dialogueStarted = false
    end
  end

  talkingToNPC = false
end
