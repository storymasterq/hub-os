<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.12.2" name="gate" tilewidth="34" tileheight="52" tilecount="10" columns="5" objectalignment="bottom">
 <grid orientation="isometric" width="64" height="32"/>
 <properties>
  <property name="Solid" type="bool" value="true"/>
 </properties>
 <image source="gate.png" width="170" height="104"/>
 <tile id="0">
  <objectgroup draworder="index" id="3">
   <object id="3" x="7" y="22.5" width="33" height="32"/>
  </objectgroup>
  <animation>
   <frame tileid="0" duration="50"/>
   <frame tileid="1" duration="50"/>
   <frame tileid="2" duration="50"/>
   <frame tileid="3" duration="50"/>
  </animation>
 </tile>
 <tile id="5">
  <animation>
   <frame tileid="5" duration="100"/>
   <frame tileid="6" duration="100"/>
   <frame tileid="7" duration="100"/>
   <frame tileid="6" duration="100"/>
  </animation>
 </tile>
</tileset>
