<p align="center">
  <img src="assets/hero.png" alt="DeskPet — chèvre cyberpunk néon" width="520">
</p>

# DeskPet 🐐

Compagnon de bureau flottant pour **macOS** : une **chèvre cyberpunk néon** qui
vit sur le bureau, se balade, réagit à l'activité en cours, garde une mémoire,
et dont l'humeur évolue avec le temps et au fil des interactions.

<p align="center">
  <img src="assets/showcase.png" alt="Poses de la chèvre" width="900">
</p>

## Fonctionnalités

- **Présence sur le bureau** : fenêtre transparente always-on-top ; déplacements
  autonomes (marche, course, assis, dodo, saut) avec rendu *squash & stretch*,
  et déplacement manuel à la souris.
- **Personnalité évolutive** : des jauges (énergie, affection, ennui) et des
  traits (sarcasme, tendresse) dérivent avec le temps ; croissance par stades
  (chevreau → jeune → adulte), mémoire des faits marquants, remarques spontanées
  et réaction au retour après une absence.
- **Observation de l'activité** (4 niveaux) :
  1. Nouveaux fichiers sur le Bureau / Téléchargements
  2. Captures d'écran et images déposées
  3. Application au premier plan + ouverture / fermeture d'applications
  4. Lancement / arrêt d'outils en ligne de commande (nmap, docker, hashcat…)

  À chaque événement, la chèvre pioche parmi **1910 répliques scriptées**, choisies
  selon la situation, son humeur *et* l'heure qu'il est (faim vers midi, coup de
  mou l'après-midi, bâillements le soir) — instantané et léger, sans modèle local.
  Un sélecteur anti-répétition écarte les 80 dernières répliques servies.
- **Synchronisation multi-Macs** : la mémoire et l'état sont écrits dans iCloud
  Drive ; la même chèvre est disponible sur chaque Mac.

## Prérequis

- macOS 14+ et **Swift** (les Command Line Tools suffisent : `xcode-select --install`)

Aucune dépendance externe : les répliques sont scriptées, il n'y a plus de
modèle local à installer ni de serveur à lancer.

## Lancer

```sh
swift run DeskPet
```

Build optimisé (usage quotidien / lancement au démarrage) :

```sh
swift build -c release
.build/release/DeskPet
```

## Lancement au démarrage (optionnel)

Un LaunchAgent (`~/Library/LaunchAgents/com.deskpet.plist`) pointant vers le
binaire *release* le lance à l'ouverture de session :

```sh
launchctl load -w ~/Library/LaunchAgents/com.deskpet.plist   # activer
launchctl unload ~/Library/LaunchAgents/com.deskpet.plist    # désactiver
```

## État persistant

`~/Library/Mobile Documents/com~apple~CloudDocs/DeskPet/state.json`
(repli local dans `~/Library/Application Support/DeskPet/` en l'absence d'iCloud).
Ce fichier n'est **jamais** versionné.

## Structure

| Fichier | Rôle |
|---|---|
| `PetController.swift` | Déplacement, machine à états d'animation, squash & stretch |
| `CreatureView.swift` / `GoatSprite.swift` | Rendu des sprites |
| `PetBrain.swift` | Personnalité, aiguillage des réactions, humeur |
| `ScriptedLines.swift` | Mécanique des répliques : anti-répétition, humeurs, tranches horaires |
| `LinesPoke.swift` | Réactions au clic, déclinées par humeur (175) |
| `LinesTimeOfDay.swift` | Répliques selon le moment de la journée (200) |
| `LinesFiles.swift` | Réactions aux fichiers apparus sur le bureau (242) |
| `LinesTools.swift` | Réactions aux outils sécu / dev lancés ou arrêtés (380) |
| `LinesApps.swift` / `LinesAppsWork.swift` | Réactions aux applications, perso et pro (813) |
| `LinesLife.swift` | Retour après absence, ennui, fatigue (100) |
| `PetState.swift` | État persistant (jauges, mémoire, croissance) + sync iCloud |
| `DesktopWatcher.swift` / `ProcessWatcher.swift` | Observation fichiers & process |
