import Foundation

/// Répliques pour les applications de travail (bureautique, IDE, admin système).
extension ScriptedLines {

    static let appBanksWork: [String: AppBank] = {
        var d = [String: AppBank]()

        d["microsoft word"] = AppBank(
            focus: [
                "Word et toi, une longue histoire de mise en page.",
                "Le sommaire automatique se met à jour quand il veut.",
                "Tu écris vite, le correcteur souligne encore plus vite.",
                "Ce paragraphe a changé de police tout seul, encore.",
                "Trois pages écrites, deux relues, une gardée.",
                "Les styles existent, Word fait semblant de l'ignorer.",
            ],
            launch: [
                "Word ouvert, le rapport ne s'écrira pas seul.",
                "Page blanche numéro un, on connait la suite.",
                "Je parie sur une image qui saute en page trois.",
                "Nouveau document, nouvel espoir de plan propre.",
                "Word démarre, prépare tes marges du dimanche.",
            ],
            quit: [
                "Document fermé, j'espère que tu as enregistré.",
                "Word se referme, la mise en page a survécu.",
                "Fin du chapitre, littéralement.",
                "Tu as gagné contre les puces automatiques, bravo.",
                "Word part se reposer, toi aussi peut-être.",
            ])

        d["microsoft excel"] = AppBank(
            focus: [
                "Cette colonne s'appelle vraiment colonne finale bis.",
                "Excel affiche des dièses, il boude la largeur.",
                "Une formule imbriquée sur six niveaux, joli travail.",
                "Le tableau croisé dynamique t'obéit, respect.",
                "Tu tries, il filtre, vous vous comprenez.",
                "Ce classeur a plus d'onglets qu'un dossier entier.",
            ],
            launch: [
                "Excel ouvert, les cellules t'attendent au tournant.",
                "Feuille vierge, quadrillage infini, bon courage.",
                "Je prédis une RECHERCHEV avant cinq minutes.",
                "Excel démarre, prépare tes plages nommées.",
                "Nouveau classeur, ancien problème de format de date.",
            ],
            quit: [
                "Excel fermé, les chiffres cessent de bouger.",
                "Classeur sauvé, tableau croisé au repos.",
                "Fini les formules, place au reste.",
                "Tu as dompté ce fichier, il s'incline.",
                "Excel se retire, les colonnes sont alignées.",
            ])

        d["microsoft powerpoint"] = AppBank(
            focus: [
                "Cette diapo a beaucoup de texte pour une soutenance.",
                "La transition en rotation, un choix courageux.",
                "Tu déplaces cette zone au pixel près depuis longtemps.",
                "Le mode plan existe, tu préfères le glisser déposer.",
                "Slide vingt-deux, le public tiendra bon.",
                "Un titre, trois puces, c'est déjà très bien.",
            ],
            launch: [
                "PowerPoint ouvert, la soutenance approche visiblement.",
                "Nouveau diaporama, je surveille les animations douteuses.",
                "Je parie sur un fondu enchainé dans dix minutes.",
                "PowerPoint démarre, choisis un thème et tiens t'y.",
                "Présentation en préparation, garde les slides courtes.",
            ],
            quit: [
                "Diaporama fermé, les animations se calment.",
                "PowerPoint s'éteint, ton public est sauvé.",
                "Slides bouclées, reste à les dire à voix haute.",
                "Fin de la répétition, la suite est orale.",
                "PowerPoint part, il te laisse le trac.",
            ])

        d["microsoft outlook"] = AppBank(
            focus: [
                "Quarante-deux non lus, tu en ouvres trois.",
                "Cette réunion aurait pu être un mail, ironie totale.",
                "Tu relis ce mail pour la quatrième fois avant envoi.",
                "Le calendrier de la semaine ressemble à un mur.",
                "Répondre à tous, le bouton le plus dangereux.",
                "Les règles de tri font le travail à ta place.",
            ],
            launch: [
                "Outlook ouvert, les non lus se réjouissent.",
                "Boite mail lancée, je compte les invitations surprises.",
                "Je prédis une réunion ajoutée sans te demander.",
                "Outlook démarre, prépare ton café d'abord.",
                "Les mails arrivent, réponds aux trois vrais.",
            ],
            quit: [
                "Outlook fermé, la boite peut attendre demain.",
                "Plus de notifications, ton cerveau te remercie.",
                "Tu as vidé la pile, ou tu as fui, on verra.",
                "Boite mail au repos, réunion évitée.",
                "Outlook s'en va, le silence est agréable.",
            ])

        d["onenote"] = AppBank(
            focus: [
                "Tu prends des notes très propres, tu les reliras jamais.",
                "Ce bloc contient trois sections et douze pages orphelines.",
                "La note du mois dernier était déjà pertinente.",
                "Tu écris plus vite que tu ne classes.",
                "OneNote garde tout, même les brouillons du mardi.",
                "Cette page s'appelle divers, courage pour la retrouver.",
            ],
            launch: [
                "OneNote ouvert, la mémoire externe démarre.",
                "Nouvelle page, ancien réflexe de tout noter.",
                "Je parie que cette note finira dans divers.",
                "OneNote se lance, note l'essentiel cette fois.",
                "Bloc notes ouvert, écris avant d'oublier.",
            ],
            quit: [
                "OneNote fermé, tes idées sont rangées quelque part.",
                "Notes enregistrées, relecture prévue jamais.",
                "Bloc refermé, la mémoire reprend le relais.",
                "Tu as capturé l'essentiel, c'est déjà bien.",
                "OneNote part, tes pages t'attendent sagement.",
            ])

        d["royal tsx"] = AppBank(
            focus: [
                "Onze onglets de serveurs ouverts, tu gères vraiment.",
                "Cette session RDP rame plus que les autres.",
                "Tu navigues entre les dossiers comme dans ta poche.",
                "Le serveur du fond répond enfin, patience récompensée.",
                "Royal TSX affiche une forêt de connexions.",
                "Un onglet SSH oublié depuis ce matin, salut à lui.",
            ],
            launch: [
                "Royal TSX ouvert, la salle des machines t'attend.",
                "Connexions distantes en approche, choisis ta cible.",
                "Je parie sur un mot de passe expiré quelque part.",
                "Royal TSX démarre, les serveurs frémissent.",
                "Tu ouvres le trousseau des accès, ferme bien après.",
            ],
            quit: [
                "Royal TSX fermé, les sessions distantes coupées.",
                "Tous les onglets serveurs sont partis dormir.",
                "Fin de la ronde sur les machines.",
                "Plus de tunnel ouvert, c'est propre.",
                "Royal TSX s'en va, les serveurs continuent sans toi.",
            ])

        d["intellij"] = AppBank(
            focus: [
                "IntelliJ indexe encore, il prend son temps.",
                "Ce refactoring touche quarante fichiers, respire un coup.",
                "Le ventilateur accompagne ta compilation.",
                "Tu as trois warnings et beaucoup de sang froid.",
                "IntelliJ propose une suggestion, tu la connais déjà.",
                "Le projet Java grandit à vue d'oeil.",
            ],
            launch: [
                "IntelliJ démarre, la mémoire vive se prépare.",
                "Je prédis une indexation de deux minutes minimum.",
                "IDE ouvert, que la compilation commence.",
                "IntelliJ se lance, ton Mac fait de la musculation.",
                "Projet Java en approche, garde ton café chaud.",
            ],
            quit: [
                "IntelliJ fermé, la RAM revient à la maison.",
                "Fin de session Java, le ventilateur se tait.",
                "L'IDE s'en va, ton Mac respire enfin.",
                "Code sauvegardé, indexation terminée pour toujours.",
                "IntelliJ part, la compilation avec lui.",
            ])

        d["pycharm"] = AppBank(
            focus: [
                "PyCharm te dit que cet import n'est pas utilisé.",
                "L'environnement virtuel du projet est enfin le bon.",
                "Tu écris du Python propre, il souligne quand même.",
                "Ce script fait trois lignes et beaucoup de dépendances.",
                "Le débogueur s'arrête pile où il faut.",
                "PyCharm indexe les paquets, ça bouge en bas.",
            ],
            launch: [
                "PyCharm démarre, active le bon environnement virtuel.",
                "Je parie sur un module manquant dans deux minutes.",
                "IDE Python ouvert, les serpents sont réveillés.",
                "PyCharm se lance, ton interpréteur t'attend.",
                "Projet Python en approche, bon code à toi.",
            ],
            quit: [
                "PyCharm fermé, ton environnement se désactive tout seul.",
                "Fin de la session Python, script au repos.",
                "L'IDE part, le terminal prend le relais peut-être.",
                "Code rangé, dépendances tranquilles.",
                "PyCharm s'en va, les tests passeront demain.",
            ])

        d["datagrip"] = AppBank(
            focus: [
                "Cette requête a quatre jointures et beaucoup d'ambition.",
                "DataGrip complète tes tables mieux que ta mémoire.",
                "Tu as mis un LIMIT, sage décision.",
                "Le plan d'exécution est presque lisible aujourd'hui.",
                "Trente-deux mille lignes retournées, tout va bien.",
                "Le schéma de cette base ressemble à un plan de métro.",
            ],
            launch: [
                "DataGrip ouvert, les bases se tiennent prêtes.",
                "Je parie sur un SELECT étoile pour commencer.",
                "Client SQL lancé, vise la bonne base cette fois.",
                "DataGrip démarre, teste avant de mettre à jour.",
                "Connexion aux bases, prudence sur la production.",
            ],
            quit: [
                "DataGrip fermé, les connexions SQL relâchées.",
                "Requêtes terminées, la base souffle.",
                "Fin de l'interrogatoire des tables.",
                "Tu es sortie sans rien casser, joli.",
                "DataGrip part, les index se reposent.",
            ])

        d["webstorm"] = AppBank(
            focus: [
                "Le linter a un avis sur chacune de tes lignes.",
                "Ce fichier JavaScript grandit plus vite que prévu.",
                "WebStorm reformate au bon endroit, pour une fois.",
                "Tu as fermé toutes les accolades, mission accomplie.",
                "Le rechargement à chaud suit ton rythme.",
                "Une dépendance de plus dans le projet web.",
            ],
            launch: [
                "WebStorm ouvert, le front attend ton avis.",
                "Je prédis une erreur de console dans la minute.",
                "IDE web lancé, que le JavaScript coule.",
                "WebStorm démarre, ton navigateur va rafraichir souvent.",
                "Projet web en approche, bon courage avec le CSS.",
            ],
            quit: [
                "WebStorm fermé, le serveur de dev peut souffler.",
                "Fin du front, la page reste telle quelle.",
                "L'IDE web s'en va, plus de rechargement automatique.",
                "Code JavaScript rangé, linter au silence.",
                "WebStorm part, ton navigateur se calme.",
            ])

        d["android studio"] = AppBank(
            focus: [
                "L'émulateur met un temps fou à afficher l'écran.",
                "Gradle synchronise encore, tu attends avec dignité.",
                "Ton téléphone virtuel a moins de patience que toi.",
                "Cette vue XML a plus d'attributs qu'un formulaire.",
                "La compilation avance, doucement mais sûrement.",
                "Android Studio mange la mémoire au petit déjeuner.",
            ],
            launch: [
                "Android Studio démarre, prends un café long.",
                "Je parie sur une synchronisation Gradle interminable.",
                "IDE mobile ouvert, l'émulateur se réveille lentement.",
                "Android Studio se lance, ton Mac chauffe déjà.",
                "Projet mobile en approche, patience obligatoire.",
            ],
            quit: [
                "Android Studio fermé, l'émulateur s'éteint enfin.",
                "Gradle se tait, quel silence agréable.",
                "Fin du mobile, ton Mac récupère sa mémoire.",
                "L'IDE part, le ventilateur ralentit.",
                "Android Studio s'en va, ton application aussi.",
            ])

        d["postman"] = AppBank(
            focus: [
                "Statut deux cents, ça commence bien la journée.",
                "Cette collection a plus de requêtes que ton historique.",
                "Le token expire pile quand tu testes, évidemment.",
                "Tu lis le JSON de réponse comme un roman.",
                "Une erreur quatre cent un, vérifie l'en-tête.",
                "Les variables d'environnement font tout le travail.",
            ],
            launch: [
                "Postman ouvert, les API vont être questionnées.",
                "Je parie sur une erreur d'authentification au premier essai.",
                "Client HTTP lancé, choisis le bon environnement.",
                "Postman démarre, prépare tes en-têtes.",
                "Tests d'API en approche, vise le bon serveur.",
            ],
            quit: [
                "Postman fermé, les API respirent à nouveau.",
                "Fin des requêtes, les réponses sont archivées.",
                "Tu as testé, ça répond, c'est déjà énorme.",
                "Collection rangée, tokens au repos.",
                "Postman part, plus personne ne pingue le serveur.",
            ])

        d["docker desktop"] = AppBank(
            focus: [
                "Six conteneurs tournent, tu en utilises deux.",
                "Les images occupent une place indécente sur le disque.",
                "Ce conteneur redémarre en boucle depuis ce matin.",
                "La baleine tourne, ton ventilateur aussi.",
                "Un volume orphelin traine quelque part, comme toujours.",
                "Docker construit l'image, couche après couche.",
            ],
            launch: [
                "Docker Desktop démarre, le moteur se réveille.",
                "Je prédis un disque plein avant la fin du mois.",
                "Conteneurs en approche, garde un oeil sur la mémoire.",
                "Docker se lance, prépare tes ports libres.",
                "Le moteur monte, pense au nettoyage un jour.",
            ],
            quit: [
                "Docker fermé, tous les conteneurs sont stoppés.",
                "Le moteur s'éteint, ton disque respire un peu.",
                "Fin des conteneurs, la mémoire revient.",
                "Docker part, ton Mac reprend des couleurs.",
                "Plus de baleine à l'horizon, calme plat.",
            ])

        d["parallels"] = AppBank(
            focus: [
                "Windows tourne dans une fenêtre, c'est presque poétique.",
                "La machine virtuelle prend la moitié de ta mémoire.",
                "Deux systèmes en même temps, tu jongles bien.",
                "Windows installe une mise à jour, évidemment maintenant.",
                "Le presse papier partagé fonctionne, quel luxe.",
                "Ta machine virtuelle a plus de disque que prévu.",
            ],
            launch: [
                "Parallels démarre, Windows se réveille en douceur.",
                "Je parie sur une mise à jour Windows imminente.",
                "Machine virtuelle en approche, garde de la mémoire.",
                "Parallels se lance, deux systèmes valent mieux qu'un.",
                "Windows arrive sur ton Mac, courage.",
            ],
            quit: [
                "Parallels fermé, Windows retourne dans sa boite.",
                "La machine virtuelle est suspendue, mémoire libérée.",
                "Fin du double système, ton Mac est seul maitre.",
                "Windows s'endort, ton ventilateur aussi.",
                "Parallels part, la RAM te dit merci.",
            ])

        d["remote desktop"] = AppBank(
            focus: [
                "Le curseur du serveur a un léger retard sur toi.",
                "Le fond d'écran distant est resté bleu par défaut.",
                "Tu travailles sur une machine à des kilomètres, tranquille.",
                "La résolution distante te fait plisser les yeux.",
                "Ce serveur Windows a un menu démarrer d'époque.",
                "La session tient bon, c'est déjà une victoire.",
            ],
            launch: [
                "Bureau à distance ouvert, le serveur t'accueille.",
                "Je parie sur un certificat qui râle au passage.",
                "Session distante en approche, ferme la en partant.",
                "Connexion lancée, vérifie que c'est le bon serveur.",
                "Le bureau distant se charge, patience de quelques secondes.",
            ],
            quit: [
                "Session distante fermée, le serveur reste seul.",
                "Bureau à distance coupé, connexion terminée proprement.",
                "Fin de la visite chez le serveur Windows.",
                "Déconnectée, c'est plus propre que de fermer la fenêtre.",
                "Le bureau distant s'efface, retour à ton écran.",
            ])

        d["citrix"] = AppBank(
            focus: [
                "Citrix affiche le clic avec une seconde de décalage.",
                "La fenêtre distante a sa propre idée du temps.",
                "Tu attends le chargement avec une patience remarquable.",
                "Le presse papier distant fait ce qu'il peut.",
                "Cette session rame, ce n'est pas ta faute.",
                "Citrix redimensionne la fenêtre quand ça lui chante.",
            ],
            launch: [
                "Citrix démarre, arme toi de patience.",
                "Je prédis un temps de chargement légendaire.",
                "Accès distant en approche, la lenteur est incluse.",
                "Citrix se lance, prends ton mal en patience.",
                "Session d'entreprise ouverte, souffle un coup.",
            ],
            quit: [
                "Citrix fermé, la latence disparait avec lui.",
                "Session d'entreprise terminée, tu as survécu.",
                "Fin du décalage entre ton clic et l'écran.",
                "Citrix part, ton Mac redevient réactif.",
                "Déconnexion réussie, quelle libération.",
            ])

        d["filezilla"] = AppBank(
            focus: [
                "Le transfert avance, barre après barre.",
                "La file d'attente contient plus de fichiers que prévu.",
                "Panneau gauche local, panneau droit distant, classique.",
                "Ce dossier distant n'a pas changé depuis deux ans.",
                "Le transfert reprend là où il s'était arrêté, bien.",
                "Tu glisses les fichiers, FileZilla suit le rythme.",
            ],
            launch: [
                "FileZilla ouvert, choisis SFTP plutôt que FTP.",
                "Je parie sur un dossier distant introuvable.",
                "Transfert de fichiers en approche, vise le bon serveur.",
                "FileZilla démarre, la file d'attente est vide pour l'instant.",
                "Connexion au serveur de fichiers, bon courage.",
            ],
            quit: [
                "FileZilla fermé, tous les transferts sont terminés.",
                "Connexion coupée, les fichiers sont arrivés.",
                "Fin du va et vient entre les deux panneaux.",
                "Transferts bouclés, serveur tranquille.",
                "FileZilla part, la file d'attente est vidée.",
            ])

        d["cyberduck"] = AppBank(
            focus: [
                "Le canard transfère tranquillement en arrière plan.",
                "Ce signet distant est bien pratique, avoue.",
                "L'interface reste calme même avec dix fichiers.",
                "Tu montes un dossier distant comme un local, magique.",
                "Le transfert avance sans faire de bruit.",
                "Cyberduck se souvient de tous tes serveurs.",
            ],
            launch: [
                "Cyberduck ouvert, le canard prend son envol.",
                "Je parie sur un signet que tu vas chercher longtemps.",
                "Transfert lancé, vérifie le protocole avant d'envoyer.",
                "Cyberduck démarre, tes serveurs sont dans les signets.",
                "Connexion distante en approche, tout va bien se passer.",
            ],
            quit: [
                "Cyberduck fermé, le canard va se poser.",
                "Transferts finis, connexion distante fermée.",
                "Fin du trajet entre ton Mac et le serveur.",
                "Les fichiers sont là où il faut, mission remplie.",
                "Cyberduck part, silence sur le réseau.",
            ])

        d["keepass"] = AppBank(
            focus: [
                "Ta base fait deux cents entrées, joli patrimoine.",
                "Le générateur propose du trente-deux caractères, prends le.",
                "Tu cherches une entrée par mot clé, efficace.",
                "Le presse papier s'effacera tout seul dans dix secondes.",
                "Cette entrée date de deux mille dix-neuf, à renouveler.",
                "Verrouille la base avant de partir en pause.",
            ],
            launch: [
                "KeePass ouvert, le coffre attend sa phrase secrète.",
                "Base de mots de passe déverrouillée, à toi de jouer.",
                "Je parie que tu cherches une entrée de deux mille vingt.",
                "KeePass démarre, ton trousseau est prêt.",
                "Le coffre s'ouvre, sers toi et referme.",
            ],
            quit: [
                "KeePass fermé, la base est verrouillée.",
                "Coffre refermé, tes secrets sont au chaud.",
                "Fin de la consultation du trousseau.",
                "Base sauvegardée, tout est en ordre.",
                "KeePass part, les mots de passe restent dedans.",
            ])

        d["1password"] = AppBank(
            focus: [
                "Le remplissage automatique t'évite trois erreurs de frappe.",
                "Ce coffre partagé est mieux rangé que ton bureau.",
                "Le rapport de sécurité signale deux mots de passe faibles.",
                "Tu as des codes à usage unique intégrés, très pratique.",
                "Cette entrée n'a pas bougé depuis longtemps.",
                "1Password trie tes identités sans se plaindre.",
            ],
            launch: [
                "1Password ouvert, ton trousseau est disponible.",
                "Je parie sur un remplissage automatique dans dix secondes.",
                "Gestionnaire lancé, verrouille le en quittant ton bureau.",
                "1Password démarre, tes coffres sont prêts.",
                "Le trousseau se déverrouille, à toi de choisir.",
            ],
            quit: [
                "1Password fermé, tout est reverrouillé.",
                "Coffres au repos, identifiants protégés.",
                "Fin de la session, ton trousseau est sûr.",
                "1Password part, plus rien n'est en clair.",
                "Gestionnaire refermé, mission sécurité accomplie.",
            ])

        d["bitwarden"] = AppBank(
            focus: [
                "Le coffre open source fait très bien son travail.",
                "Tu as des dossiers, des collections et un vrai système.",
                "Ce mot de passe est réutilisé, Bitwarden te le dit.",
                "La synchronisation entre appareils suit sans broncher.",
                "Le générateur de phrase secrète est plutôt inspiré.",
                "Ton coffre est chiffré de bout en bout, tranquille.",
            ],
            launch: [
                "Bitwarden ouvert, le coffre se déverrouille.",
                "Je parie sur une recherche par nom de site.",
                "Gestionnaire lancé, referme le après usage.",
                "Bitwarden démarre, tes identifiants sont là.",
                "Coffre ouvert, sers toi tranquillement.",
            ],
            quit: [
                "Bitwarden fermé, le coffre est reverrouillé.",
                "Synchronisation faite, identifiants rangés.",
                "Fin de la consultation, tout est chiffré.",
                "Bitwarden part, tes secrets restent secrets.",
                "Coffre refermé, rien ne traine en mémoire.",
            ])

        d["obsidian"] = AppBank(
            focus: [
                "Ton graphe de notes ressemble à une carte du ciel.",
                "Cette note relie six autres notes, belle toile.",
                "Le markdown reste lisible même dans dix ans.",
                "Tu as une note orpheline, elle attend un lien.",
                "Les liens entre crochets font tout le travail.",
                "Ce coffre de notes grandit à chaque semaine.",
            ],
            launch: [
                "Obsidian ouvert, ton second cerveau démarre.",
                "Je parie sur une nouvelle note reliée à trois autres.",
                "Coffre de notes lancé, écris en markdown tranquille.",
                "Obsidian démarre, le graphe t'attend.",
                "Prise de notes en approche, relie bien tes idées.",
            ],
            quit: [
                "Obsidian fermé, tes notes sont en markdown sur disque.",
                "Le graphe se fige, les idées restent.",
                "Fin de la session, ton coffre est sauvegardé.",
                "Obsidian part, tes liens tiennent bon.",
                "Notes rangées, second cerveau en veille.",
            ])

        d["sublime"] = AppBank(
            focus: [
                "Sublime ouvre ce fichier énorme sans broncher.",
                "La sélection multiple, ton petit plaisir du jour.",
                "Aucun temps de chargement, quel confort.",
                "Tu édites en trois secondes ce que l'IDE mettrait longtemps.",
                "La minicarte à droite te sert vraiment, finalement.",
                "Ce fichier de config est presque joli maintenant.",
            ],
            launch: [
                "Sublime ouvert, instantané comme toujours.",
                "Je parie sur une édition rapide et une fermeture immédiate.",
                "Éditeur léger lancé, parfait pour un coup d'oeil.",
                "Sublime démarre en un clin d'oeil, comme prévu.",
                "Fichier ouvert, pas besoin d'artillerie lourde.",
            ],
            quit: [
                "Sublime fermé, aussi vite qu'il s'était ouvert.",
                "Édition rapide terminée, fichier sauvé.",
                "Fin du passage éclair dans l'éditeur.",
                "Sublime part sans faire de bruit.",
                "Le fichier est propre, mission accomplie.",
            ])

        d["github desktop"] = AppBank(
            focus: [
                "Vingt-trois fichiers modifiés, ça sent le gros commit.",
                "Ce message de commit mérite mieux que corrections diverses.",
                "Le diff est lisible, tu as bien découpé.",
                "Tu es sur une branche de fonctionnalité, très sage.",
                "La pull request attend une relecture depuis hier.",
                "Historique propre, on dirait presque du travail rangé.",
            ],
            launch: [
                "GitHub Desktop ouvert, prépare tes commits.",
                "Je parie sur un commit intitulé fix avant ce soir.",
                "Interface Git lancée, crée une branche d'abord.",
                "GitHub Desktop démarre, ton dépôt t'attend.",
                "Versionnage en approche, découpe bien tes changements.",
            ],
            quit: [
                "GitHub Desktop fermé, tout est poussé j'espère.",
                "Commits enregistrés, branche à jour.",
                "Fin de la session Git, historique tranquille.",
                "GitHub Desktop part, ton dépôt reste en ligne.",
                "Travail versionné, tu peux dormir sereine.",
            ])

        return d
    }()
}
