REM === IMPORTANT: You need to install Docker Desktop to run this batch file! ===
REM === See: https://www.docker.com/

REM --- Download the latest ScorpioStation image from Docker Hub ---
docker pull scorpiostation/scorpio:latest

REM --- Create a ScorpioStation container to copy files from ---
docker create --name delete_me scorpiostation/scorpio:latest

REM --- Copy build resources from container to code folders ---
docker cp delete_me:/scorpio/tgui/packages/tgui/public/tgui.bundle.css tgui/packages/tgui/public/tgui.bundle.css
docker cp delete_me:/scorpio/tgui/packages/tgui/public/tgui.bundle.js tgui/packages/tgui/public/tgui.bundle.js
docker cp delete_me:/scorpio/nano/images/Emerald_nanomap_z1.png nano/images/Emerald_nanomap_z1.png

REM --- Remove the ScorpioStation container ---
docker rm delete_me
