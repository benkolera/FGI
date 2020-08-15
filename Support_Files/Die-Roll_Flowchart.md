# Die-Roll Flowchart

---

Version 1.0.0

The following is a flow&ndash;chart of an FG UDR Die Roll. It includes the files and functions that are called, showing the flow from one file:function to another and the flow of dependencies from one file:function to another.

If you have any further questions or require any further help, please see the Project&rsquo;s [FAQs](https://github.com/Dulux-Oz/FGI/tree/master/Project_Documentation/FAQs.md) Document, or don&rsquo;t hesitate to email the Project on <fgi@freelists.org>.


## Die Roll Cases

### Case 1 &mdash; Rolling Dice In Chat Box

ACTION: Drag Die To Chatbox

~~~
  |
  +-Chatbox:onDrop(x, y, draginfo)
     |
     +-ActionsManager.actionDrop(draginfo, rTarget=nil)
        |
        +-ActionsManager.decodeActionFromDrag(draginfo, bFinal=false) - returns rSource,rRolls,aTargets
        |  |
        |  +-ActionsManager.decodeActors(draginfo) - returns rSource,aTargets
        |  |  |
        |  |  +-ActorManager.getActor()
        |  |
        |  +-ActionsManager.decodeRollFromDrag(draginfo,i,bFinal) - returns vRoll
        |
        +-ActionsManager.getTargeting(rSource, rTarget, sDragType, rRolls)
        |
        +-GoTo ACTION_ROLL
~~~

### Case 2 &mdash; Rolling Dice In Tower

ACTION: Drag Die To DiceTower


~~~
  |
  +-DiceTower windowclass onDrop
  |
  +-DiceTowerManager.onDrop(draginfo)
     |
     +-ActionsManager.actionDropHelper(draginfo, false)
     |  |
     |  +-ActionsManager.decodeActors(draginfo)
     |  |  |
     |  |  +-ActorManager.getActor(v.class, v.recordname)
     |  |
     |  +-ActionsManager.lockModifiers();
     |  |
     |  +-ActionsManager.applyModifiersToDragSlot(draginfo, i, rSource, bResolveIfNoDice)
     |  |  |
     |  |  +-ActionsManager.decodeRollFromDrag(draginfo, i)
     |  |  |
     |  |  +-ActionsManager.applyModifiers(rSource, nil, rRoll)
     |  |  |  |
     |  |  |  +-fMod(rSource, rTarget, rRoll) - if exist --- May be place to do DieCodes
     |  |  |
     |  |  +-EITHER
     |  |  |  |
     |  |  |  +-ActionsManager.resolveAction(rSource, rTarget, vRoll)
     |  |  |    |
     |  |  |    +-ActionsManager.fResult - if exist, OR
     |  |  |    |
     |  |  |    +-ActionsManager.createActionMessage(rSource, rRoll)
     |  |  |    |
     |  |  |    +-Comm.deliverChatMessage(rMessage)
     |  |  |       |
     |  |  |       +-RESULT: Chat Message - Done
     |  |  |
     |  |  +-OR
     |  |     |
     |  |     +-[Set draginfo.slot(s)]
     |  |
     |  +-ActionsManager.unlockModifiers(bModStackUsed);
     |
     +-DiceTowerManager.encodeOOBFromDrag(draginfo, i, rSource)
     |
     +-Comm.deliverOOBMessage(msgOOB, "");
     |  |
     |  +-RESULT: OOB Message - GoTo DICETOWER_OOB
     |
     +-ActorManager.getDisplayName(rSource)
        |
        +-Comm.addChatMessage(msg);
           |
           +-RESULT: Chat Message - Done
~~~

### Case 3 &mdash; Using `/die` Command

ACTION: Type `/die AdB`<br />

~~~
  |
  +-ChatManager.processDie(sCommand, sParams)
     |
     +-StringManager.isDiceString(sDice)
     |
     +-StringManager.convertStringToDice(sDice)
     |
     +-[Determine Non-Standard Die & random()]
     |
     +-ActionsManager.actionDirect(nil, "dice", { rRoll })
        |
        +-GoTo ACTION_ROLL
~~~

### Case 4 &mdash; Using `/tower` Command

ACTION: Type `/tower AdB`<br />

~~~
  |
  +-ChatManager2.fpProcessTowerDie(sCommand,sParams)
     |
     +-DieManager.fpDieCodeParse(sDice)
     |
     +-DieManager.fpDieAndTowerHelper
     |  |
     |  +-[Determine Non-Standard Die & random()] - TO DO
     |
     +-[Create OOB Message]
     |
     +-DiceTowerManager2.fpSetRollCodesFromSlash(aMessageOOB,aRollCodes);
     |
     +-Comm.deliverOOBMessage(aMessageOOB,"");
     |  |
     |  +-RESULT: OOB Message - GoTo DICETOWER_OOB
     |
     +-ActorManager.getDisplayName(aSource)
        |
        +-Comm.addChatMessage(msg);
           |
           +-RESULT: Chat Message - Done
~~~

### Case 5 &mdash; Clicking Button/Numberfield (eg On Character Sheet)

ACTION: Click A Button / Double&ndash;Click A Numberfield<br />

~~~
  |
  +-ActionsManager.performAction(draginfo, rActor, rRoll)
  |
  +-ActionsManager.performMultiAction(draginfo, rActor, rRoll.sType, { rRoll })
     |
     +-EITHER
     |  |
     |  +-ActionsManager.encodeActionForDrag(draginfo, rActor, sType, rRolls);
     |     |
     |     +-ActionsManager.encodeActors(draginfo, rSource)
     |
     +-OR
        |
        +-ActionsManager.actionDirect(nil, "dice", { rRoll })
        |
        +-GoTo ACTION_ROLL
~~~

### Case 6 &mdash; From Shortcutbar

ACTION: Click On HotKey<br />

~~~
  |
  +-ActionsManager.actionDirect(nil, "dice", { rRoll })
      |
      +-GoTo ACTION_ROLL
~~~

## Common Flows

### ACTION_ROLL

~~~
  |
  +-ActionsManager.actionRoll(rActor, aTargeting, rRolls)
     |
     +-ActionsManager.lockModifiers()
     |
     +-ActionsManager.applyModifiersAndRoll(rSource, vTargetGroup, true, vRoll)
     |  |
     |  +-ActionsManager.applyModifiers(rSource, vTarget, rNewRoll)
     |  |  |
     |  |  +-fMod(rSource, rTarget, rRoll) - if exist --- May be place to do DieCodes
     |  |
     |  +-GoTo ROLL
     |
     +-ActionsManager.unlockModifiers()
~~~

### DICETOWER_OOB

~~~
  |
  +-ActorManager.getActor(nil, msgOOB.sender);
  |
  +-StringManager.convertStringToDice(msgOOB.sDice);
  |
  + GoTo ROLL
~~~

### ROLL

~~~
  |
  +-ActionsManager.roll(rSource, vTarget, rNewRoll, bMultiTarget)
     |
     +-EITHER
     |  |
     |  +-Manual Roll
     |
     +-OR
     |  |
     |  +-ActionsManager.buildThrow(rSource, vTargets, rRoll, bMultiTarget);
     |  |  |
     |  |  +-ActorManager.getTypeAndNodeName(rSource)
     |  |
     |  +-Comm.throwDice(rThrow);
     |     |
     |     +-RESULT: Dice Roll In Chat Box - GoTo ON\_DICE\_LANDED
     |
     +-OR
        |
        +-ActionsManager.handleResolution(vRoll, rSource, aTargets)
           |
           +-ActionsManager.fPostRoll - if exists
           |
           +-ActionsManager.resolveAction(rSource, rTarget, vRoll)
              |
              +-ActionsManager.fResult - if exist, OR
              |
              +-ActionsManager.createActionMessage(rSource, rRoll)
              |
              +-Comm.deliverChatMessage(rMessage)
                 |
                 +-RESULT: Chat Message - Done
~~~

### ON\_DICE\_LANDED

~~~
  |
  +-Chatbox:onDiceLanded(draginfo)
  |
  +-ActionsManager.onDiceLanded(draginfo)
     |
     +-ActionsManager.decodeActionFromDrag(draginfo,bFinal=true) - returns rSource,rRolls,aTargets
     |  |
     |  +-ActionsManager.decodeActors(draginfo) - returns rSource,aTargets
     |  |  |
     |  |  +-ActorManager.getActor()
     |  |
     |  +-ActionsManager.decodeRollFromDrag(draginfo,i,bFinal) - return vRoll
     |
     +-ActionsManager.handleResolution(vRoll, rSource, aTargets)
        |
        +-ActionsManager.fPostRoll - if exists
        |
        +-ActionsManager.resolveAction(rSource, rTarget, vRoll)
           |
           +-EITHER
           |  |
           |  +-ActionsManager.fResult - if exist
           |
           +-OR
              |
              +-ActionsManager.createActionMessage(rSource, rRoll)
              |
              +-Comm.deliverChatMessage(rMessage)
                 |
                 +-RESULT: Chat Message - Done
~~~

## Notes

Need to modify ActionsManager.lockModifiers() &amp; ActionsManager.unlockModifiers() to take into account new "Mod Boxes".

---

![Creative Commons License](https://i.creativecommons.org/l/by&ndash;sa/4.0/88x31.png "Creative Commons License")

This work is Copyright &copy;2004&ndash;2020 PEREGRINE I.T. Pty Ltd and is licensed under a [Creative Commons Attribution&ndash;ShareAlike 4.0 International License (CC BY&ndash;SA 4.0).](https://creativecommons.org/licenses/by&ndash;sa/4.0/)

All Rights Reserved.
