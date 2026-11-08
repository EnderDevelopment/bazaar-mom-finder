# Roblox Bazaar Quest Script

Bazaar Mom Finder is a Roblox script system for a search quest game: players explore a generated bazaar, earn coins from vendor tips, purchase clue upgrades, and locate a randomized target shopper representing Mom. It simulates a 100,000+ person crowd through virtual population data while using lightweight Roblox parts and NPC objects for gameplay.

## Install

1. Open Roblox Studio and create or open a Baseplate experience.
2. In `ServerScriptService`, create a Script named `BazaarMap` and paste in `BazaarMap.server.lua`.
3. In `ServerScriptService`, create a second Script named `BazaarGame` and paste in `BazaarGame.server.lua`.
4. In `StarterPlayer > StarterPlayerScripts`, create a LocalScript named `BazaarClient` and paste in `BazaarClient.client.lua`.
5. Press Play in Roblox Studio. The map script creates the `GeneratedBazaar` model, and the game script waits for that model before starting the quest.

No external assets or plugins are required.

## Use

1. Spawn at the bazaar gate and enter the generated market.
2. Use the `Ask Vendor Tip (+20)` button to earn 20 coins. Tips have a 20-second cooldown.
3. Purchase upgrades from the on-screen Upgrade Shop:
   - Directory: 25 coins. Reveals that Mom is in one of the four districts.
   - Lens: 75 coins. Reveals Mom’s district.
   - Beacon Scanner: 175 coins. Reveals Mom’s district and stall number.
4. Travel through Spice Lane, Silk Lane, Lantern Row, and Garden Court to follow the clues.
5. Find the pink shopper at the indicated stall.
6. Approach the shopper and use the Talk prompt. The Beacon Scanner is required to complete the search.
7. The target stall is randomized each server session.

The system validates coin rewards, upgrade purchases, cooldowns, and the final discovery check on the server. The 100,000+ crowd is represented by a virtual crowd-size attribute; the project does not spawn 100,000 character models.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/31f675a0-122b-4abf-bf5a-9be64e80df02?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=31f675a0-122b-4abf-bf5a-9be64e80df02
