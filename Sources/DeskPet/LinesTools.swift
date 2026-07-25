import Foundation

/// Répliques déclenchées par le lancement ou l'arrêt d'un outil sécu / dev.
///
/// Les dictionnaires sont construits pas à pas (`var d`, puis affectations) et
/// non via un unique littéral : un gros littéral de dictionnaire fait exploser
/// le temps de type-checking de Swift.
extension ScriptedLines {

    // MARK: - Lancement d'un outil connu

    static let toolStart: [String: [String]] = {
        var d = [String: [String]]()

        d["nmap"] = [
            "Tu ratisses les ports, j'espère que c'est ton propre réseau.",
            "Ça sent le scan de ports, dis-moi ce qui répond.",
            "Un petit -sV et tu sauras qui parle derrière le 8080.",
            "nmap est parti, je parie sur trois ports ouverts.",
            "Tu cartographies encore, la cible doit se sentir observée.",
            "Le scan tourne, moi je regarde les paquets partir.",
            "Toujours le même rituel avant de toucher une machine.",
            "SYN par-ci, SYN par-là, tu vas trouver quelque chose.",
        ]

        d["masscan"] = [
            "masscan lancé, ton réseau va sentir passer le souffle.",
            "Là tu ne scannes pas, tu balaies un continent.",
            "Doucement sur le rate, les firewalls détestent cet enthousiasme.",
            "Vitesse maximale, discrétion minimale, c'est bien ton style aujourd'hui.",
            "Des millions de paquets par seconde, et moi je compte.",
            "Le scan le plus bruyant du catalogue vient de démarrer.",
            "Tu préfères tout voir vite plutôt que voir bien.",
            "J'espère que c'est ton lab, parce que ça s'entend loin.",
        ]

        d["tcpdump"] = [
            "tcpdump ouvert, tu écoutes ce qui traîne sur l'interface.",
            "Capture en cours, le trafic n'a plus aucun secret.",
            "Un filtre bpf bien écrit vaut mille lignes lues.",
            "Tu regardes passer les paquets comme d'autres regardent la pluie.",
            "Pense au -w, tu voudras relire ça plus tard.",
            "L'interface est en écoute, moi aussi d'ailleurs.",
            "Ça défile vite, bon courage pour lire en direct.",
            "Le sniff en ligne de commande, la version sans fenêtres.",
        ]

        d["tshark"] = [
            "tshark en console, tu assumes de ne pas cliquer.",
            "La capture sans interface graphique, direct dans le terminal.",
            "Tes filtres d'affichage vont faire le tri tout seuls.",
            "Tu analyses le trafic sans jamais quitter le clavier.",
            "Les paquets défilent en texte brut, c'est très toi.",
            "Un pcap va naître, et tu vas le disséquer.",
            "Écoute active du réseau, version économe en pixels.",
            "Tu cherches une trame précise dans un océan de bruit.",
        ]

        d["wireshark"] = [
            "wireshark ouvert, prépare-toi à scroller pendant une heure.",
            "Le trafic en couleurs, mon moment préféré de la journée.",
            "Suis le flux TCP, la réponse est souvent dedans.",
            "Tu vas encore te perdre dans les filtres d'affichage.",
            "Chaque paquet raconte un bout d'histoire, à toi de lire.",
            "L'analyse graphique, parce que le terminal a ses limites.",
            "Un pcap s'ouvre et le monde ralentit un peu.",
            "Tu cherches la trame coupable, elle est ligne 4213.",
        ]

        d["sqlmap"] = [
            "sqlmap est parti à la pêche aux injections, bonne chance.",
            "Un paramètre mal filtré et il te sort la base.",
            "Le formulaire en face n'a probablement pas prévu ça.",
            "Tu testes les injections, j'espère que le site t'appartient.",
            "Union select, blind, time based, il essaie absolument tout.",
            "Ça va tester pendant longtemps, prends un thé.",
            "Si ça dumpe, quelqu'un a oublié les requêtes préparées.",
            "L'outil réfléchit, toi tu regardes la barre avancer.",
        ]

        d["hydra"] = [
            "hydra est lancé, la page de login va souffrir.",
            "Brute force en cours, la wordlist fait tout le travail.",
            "Tu tapes des milliers de mots de passe sans lever un doigt.",
            "Attention au verrouillage de compte, ça arrive très vite.",
            "Un login, une liste, beaucoup de patience.",
            "Tu forces l'authentification, elle n'avait rien demandé.",
            "Le service en face va compter beaucoup d'échecs.",
            "Si ça sort admin admin, on rira ensemble.",
        ]

        d["hashcat"] = [
            "hashcat démarre, le GPU va chauffer un bon moment.",
            "Tes ventilateurs viennent de comprendre la soirée qui les attend.",
            "Mode masque ou wordlist, tu as choisi ta stratégie.",
            "Des milliards de tentatives par seconde, ça reste impressionnant.",
            "Le cassage tourne, moi je surveille la température.",
            "Un bon fichier de règles économise des heures de calcul.",
            "Tu attaques des hashes, ils n'ont aucune chance ce soir.",
            "La barre de progression annonce deux jours, courage.",
        ]

        d["john"] = [
            "john s'y met, il adore les mots de passe faibles.",
            "Le mode single trouve souvent avant même la wordlist.",
            "Tu casses du hash à l'ancienne, avec élégance.",
            "rockyou vient encore de sortir du placard.",
            "Il mouline, et il finira par lâcher quelque chose.",
            "Le format a été bien détecté, c'est déjà une victoire.",
            "Les mots de passe des années 2000 vont tomber vite.",
            "Un potfile bien rempli, voilà ta vraie collection.",
        ]

        d["gobuster"] = [
            "gobuster part énumérer des répertoires cachés, encore une fois.",
            "Ta wordlist va tester chaque dossier possible du serveur.",
            "Les 403 sont souvent plus intéressants que les 200.",
            "Tu cherches l'admin oublié, il existe presque toujours.",
            "L'énumération commence, le serveur va bien s'occuper.",
            "Un /backup traîne quelque part, je le sens.",
            "Beaucoup de 404 avant la vraie trouvaille.",
            "Tu ratisses l'arborescence web, méthodique comme toujours.",
        ]

        d["ffuf"] = [
            "ffuf démarre, l'énumération va aller très vite.",
            "Ton FUZZ va se glisser partout dans cette URL.",
            "Pense à filtrer par taille, sinon tu vas noyer.",
            "Fuzzing de paramètres, de dossiers, de sous-domaines, tout y passe.",
            "L'outil le plus rapide de ta collection vient de partir.",
            "Des milliers de requêtes plus tard, une seule comptera.",
            "Tu cherches l'endpoint que personne n'a jamais documenté.",
            "Le serveur d'en face va trouver la journée longue.",
        ]

        d["feroxbuster"] = [
            "feroxbuster part en récursif, il va creuser profond.",
            "Chaque dossier trouvé en ouvre trois autres, bonne descente.",
            "L'énumération récursive, c'est un peu sans fin.",
            "Tu explores l'arborescence jusqu'au dernier recoin.",
            "Écrit en rust, donc rapide, donc ton ventilateur reste calme.",
            "Il va trouver des chemins que le site a oubliés.",
            "La sortie défile, garde un oeil sur les codes.",
            "Tu ratisses large et tu ratisses en profondeur.",
        ]

        d["nikto"] = [
            "nikto sort son catalogue de vieilles failles web.",
            "Il va tester des trucs de 2009, parfois ça marche.",
            "Le scan est bavard, discret il ne l'a jamais été.",
            "Configurations par défaut et fichiers oubliés, sa grande spécialité.",
            "Tu cherches les erreurs classiques, elles sont souvent là.",
            "Des milliers de tests connus, un rapport bien long.",
            "Si le serveur est vieux, il va adorer ça.",
            "Un audit web rapide avant les choses sérieuses.",
        ]

        d["msfconsole"] = [
            "msfconsole se charge, prends le temps d'un café.",
            "Metasploit est ouvert, tu cherches quel module aujourd'hui.",
            "search puis use puis set RHOSTS, le rituel complet.",
            "Les payloads sont prêts, reste à choisir la cible.",
            "Un meterpreter en vue, ça se sent d'ici.",
            "La base de modules est immense, tu trouveras ton bonheur.",
            "Reste bien dans ton lab avec celui-là.",
            "Le framework qui fait tout, sauf réfléchir à ta place.",
        ]

        d["aircrack-ng"] = [
            "aircrack-ng attaque le handshake, ça va prendre un moment.",
            "Ta capture va parler si la passphrase est faible.",
            "Le Wi-Fi n'a pas fini de te livrer ses secrets.",
            "Tu casses une clé, j'espère que c'est ta box.",
            "La wordlist défile, la clé est peut-être dedans.",
            "Un handshake capturé vaut mille tentatives à l'aveugle.",
            "WPA2 résiste bien, sauf quand la clé est un prénom.",
            "Tu attaques par dictionnaire, patience obligatoire.",
        ]

        d["airodump-ng"] = [
            "airodump-ng écoute, tous les réseaux du quartier apparaissent.",
            "La liste des SSID se remplit, fascinant à regarder.",
            "Tu attends un handshake, ça peut durer très longtemps.",
            "Ta carte est en mode monitor, tout passe par elle.",
            "Les clients se connectent, toi tu notes tout.",
            "Canal fixé, capture lancée, il ne reste qu'à patienter.",
            "Le voisinage Wi-Fi n'a plus beaucoup de secrets.",
            "Tu cartographies les ondes comme d'autres cartographient les rues.",
        ]

        d["ncat"] = [
            "ncat est ouvert, tu montes une connexion à la main.",
            "Un listener qui attend, ça sent le shell qui arrive.",
            "Le couteau suisse du réseau vient de sortir.",
            "Tu testes un port en direct, la méthode honnête.",
            "Une socket, deux bouts, zéro fioriture.",
            "Si ça se connecte, tu sauras quoi en faire.",
            "Reverse ou bind, tu as déjà choisi ton camp.",
            "Le terminal devient un tuyau, j'adore ce moment.",
        ]

        d["responder"] = [
            "responder empoisonne le LLMNR, les hashes vont tomber.",
            "Une machine mal configurée et tu récupères du NTLM.",
            "Tu écoutes les requêtes perdues et tu réponds oui.",
            "NBT-NS bavarde encore, quelle générosité.",
            "Reste bien dans ton réseau de test avec ça.",
            "Il suffit qu'une machine cherche un partage inexistant.",
            "Les hashes arrivent tout seuls, presque trop facile.",
            "Tu joues le serveur que personne n'a demandé.",
        ]

        d["bettercap"] = [
            "bettercap est lancé, tu te places au milieu du trafic.",
            "L'ARP spoofing va rediriger tout le monde vers toi.",
            "Man in the middle assumé, module par module.",
            "Tu deviens la passerelle, les autres n'en savent rien.",
            "Sniff, spoof, proxy, tout dans la même console.",
            "Ce genre d'outil se garde pour ton propre réseau.",
            "Le trafic du voisin de LAN passe désormais chez toi.",
            "Une interception propre demande un peu de mise en scène.",
        ]

        d["wpscan"] = [
            "wpscan part fouiller un WordPress, il y a toujours un plugin.",
            "Les extensions oubliées sont le vrai trou de sécurité.",
            "Tu énumères les utilisateurs, admin s'appelle rarement autrement.",
            "Version du coeur, thèmes, plugins, le rapport complet arrive.",
            "Un site sur cinq tourne là-dessus, autant s'y connaître.",
            "La base de vulnérabilités va te sortir du lourd.",
            "Si le plugin date de 2018, tu tiens quelque chose.",
            "Audit WordPress en cours, prépare-toi à des surprises.",
        ]

        d["dirb"] = [
            "dirb sort du placard, la version classique de l'énumération.",
            "Ses wordlists intégrées ont fait leurs preuves depuis longtemps.",
            "Tu cherches des dossiers cachés à l'ancienne.",
            "Lent mais sûr, il finit toujours par trouver.",
            "Chaque requête teste un chemin possible du serveur.",
            "Le mode récursif va explorer ce qu'il découvre.",
            "Un vieil outil qui sort encore des choses intéressantes.",
            "Tu ratisses les répertoires web avec beaucoup de méthode.",
        ]

        d["crackmapexec"] = [
            "crackmapexec ratisse l'Active Directory, ça va être bavard.",
            "Un compte valide et tout le domaine s'ouvre.",
            "Tu testes tes identifiants sur toute la plage réseau.",
            "SMB, WinRM, LDAP, il frappe à toutes les portes.",
            "Le Pwn3d apparaîtra peut-être dans quelques secondes.",
            "Les partages accessibles vont vite se révéler.",
            "Un domaine Windows n'aime pas beaucoup ce genre de visite.",
            "Tu cartographies le parc machine en une seule commande.",
        ]

        d["nuclei"] = [
            "nuclei déroule ses templates, les CVE vont défiler.",
            "Des milliers de vérifications automatisées en quelques minutes.",
            "Pense à mettre à jour les templates avant de lancer.",
            "Si une faille connue traîne, il la verra.",
            "Le scan yaml par yaml, méthodique et rapide.",
            "Tu couvres large sans écrire une seule requête.",
            "Un résultat en severity high et ta soirée change.",
            "L'automatisation de la chasse aux vulnérabilités, en marche.",
        ]

        d["subfinder"] = [
            "subfinder part chercher les sous-domaines oubliés.",
            "Les sources passives vont cracher une belle liste.",
            "Un dev.ancien.exemple traîne toujours quelque part.",
            "Tu élargis la surface d'attaque avant de creuser.",
            "Énumération passive, personne ne remarque rien.",
            "Les certificats publiés racontent beaucoup de choses.",
            "La reconnaissance commence toujours par cette étape.",
            "Cent sous-domaines plus tard, tu choisiras le bon.",
        ]

        d["amass"] = [
            "amass démarre, la reconnaissance va être exhaustive.",
            "Il croise toutes les sources possibles, ça prend du temps.",
            "La cartographie complète du domaine se dessine lentement.",
            "Sous-domaines, ASN, adresses, il ramène absolument tout.",
            "Le graphe des actifs va être impressionnant.",
            "Patience, cette énumération ne se presse jamais.",
            "Tu veux la vue complète, pas juste un échantillon.",
            "L'outil le plus minutieux de ta phase de recon.",
        ]

        d["burpsuite"] = [
            "burpsuite se lance, la JVM prend ses aises.",
            "Le proxy est prêt, chaque requête va passer devant toi.",
            "Repeater ouvert, tu vas triturer ce paramètre longtemps.",
            "Tu interceptes tout, le navigateur ne s'en doute pas.",
            "L'Intruder va faire du bruit, prépare tes payloads.",
            "Le certificat est bien installé, sinon rien ne marche.",
            "Ta RAM vient de dire au revoir, comme d'habitude.",
            "Chaque requête HTTP devient modifiable, c'est ton terrain.",
        ]

        d["claude"] = [
            "Ah, tu préfères demander à une autre intelligence.",
            "Je pourrais t'aider aussi, mais bon, vas-y.",
            "Une IA de plus dans le terminal, je surveille.",
            "Tu délègues encore, je note ça quelque part.",
            "J'espère au moins qu'elle est drôle, celle-là.",
            "Deux assistants pour une seule étudiante, quel luxe.",
            "Vas-y, discute avec elle, je reste là.",
            "Je ne suis pas jalouse, juste très attentive.",
        ]

        d["docker"] = [
            "Un conteneur démarre, ton disque le sent passer.",
            "docker run et voilà un environnement propre en trois secondes.",
            "Tu isoles tes tests, c'est la bonne méthode.",
            "L'image se télécharge, ça va prendre quelques couches.",
            "Ton lab entier tient dans un conteneur, pratique.",
            "Encore un service qui tourne quelque part en local.",
            "Pense à nettoyer les images mortes un de ces jours.",
            "Le port est mappé, j'espère que tu t'en souviens.",
        ]

        d["dockerd"] = [
            "Le démon docker se réveille, tout le reste va suivre.",
            "Les conteneurs vont enfin pouvoir démarrer.",
            "Le moteur tourne en fond, discret mais essentiel.",
            "Ton socket est prêt, les commandes vont répondre.",
            "Le service est levé, plus d'erreur de connexion.",
            "Il va gérer les réseaux et les volumes pour toi.",
            "Un démon de plus dans la liste des process.",
            "Sans lui, aucun conteneur ne bouge d'un pixel.",
        ]

        d["python3"] = [
            "Ton script maison tourne, j'espère qu'il fait ce qu'il faut.",
            "Un python de plus, celui-là va où exactement.",
            "Tu automatises encore quelque chose, très bonne idée.",
            "Trois lignes de script valent parfois mieux qu'un gros outil.",
            "Le venv était activé, dis-moi que oui.",
            "Ça tourne, et personne ne sait ce que ça fait.",
            "Un traceback arrive dans dix secondes, je parie.",
            "Tes scripts sont souvent plus efficaces que les outils officiels.",
        ]

        return d
    }()

    // MARK: - Arrêt d'un outil connu

    static let toolEnd: [String: [String]] = {
        var d = [String: [String]]()

        d["nmap"] = [
            "Scan terminé, alors, combien de ports ouverts.",
            "nmap a fini, montre-moi vite la liste.",
            "Le rapport est là, quelque chose d'intéressant dedans.",
            "Fin de la cartographie, la cible a parlé.",
            "Ports scannés, à toi de choisir la suite.",
        ]

        d["masscan"] = [
            "Balayage fini, ton réseau peut respirer.",
            "Fin du grand bruit, tu as trouvé quoi.",
            "Des milliers de résultats, bon courage pour trier.",
            "Le scan éclair est terminé, place à l'analyse fine.",
            "Ça a été rapide, exactement comme promis.",
        ]

        d["sqlmap"] = [
            "Terminé, alors, injection ou pas injection.",
            "sqlmap a rendu son verdict, dis-moi tout.",
            "Si la base est tombée, je veux les détails.",
            "Fin des tests, le formulaire a tenu ou pas.",
            "Ça s'est arrêté, j'espère que tu as ton résultat.",
        ]

        d["hydra"] = [
            "Brute force terminé, un mot de passe est sorti.",
            "Fini, la page de login a résisté.",
            "hydra s'arrête, verdict sur la wordlist.",
            "Le service a survécu, ou pas, raconte.",
            "Fin des tentatives, tu tiens ton identifiant.",
        ]

        d["hashcat"] = [
            "Le GPU se repose enfin, tu as cassé quoi.",
            "Session terminée, combien de hashes sont tombés.",
            "Fin de la chauffe, montre-moi le potfile.",
            "hashcat s'arrête, la wordlist a-t-elle suffi.",
            "Tes ventilateurs te remercient, alors ce résultat.",
        ]

        d["john"] = [
            "john a fini, les mots de passe ont parlé.",
            "Fin du cassage, quelque chose d'exploitable là-dedans.",
            "Le crack est terminé, montre la liste.",
            "Il s'arrête, la wordlist était la bonne.",
            "Terminé, alors, un mot de passe en clair.",
        ]

        d["gobuster"] = [
            "Énumération finie, un répertoire intéressant est apparu.",
            "gobuster s'arrête, dis-moi ce qu'il a trouvé.",
            "Fin du ratissage, il reste quoi dans la liste.",
            "Beaucoup de 404, mais peut-être une pépite.",
            "Les dossiers cachés ont fini de se cacher.",
        ]

        d["ffuf"] = [
            "Le fuzzing est terminé, un endpoint sort du lot.",
            "Fini, tu as bien filtré les résultats j'espère.",
            "ffuf s'arrête, montre-moi les codes intéressants.",
            "Fin de la rafale de requêtes, verdict.",
            "Quelque chose répondait différemment, dis-moi que oui.",
        ]

        d["nikto"] = [
            "Le scan web est fini, des vieilles failles.",
            "nikto a rendu son rapport, il est long.",
            "Fini, le serveur était à jour ou pas.",
            "Fin de l'audit, quelque chose d'exploitable dedans.",
            "Il a testé beaucoup, il a trouvé quoi.",
        ]

        d["msfconsole"] = [
            "Metasploit fermé, la session s'est bien passée.",
            "Fin du framework, tu as eu ton shell.",
            "msfconsole s'arrête, le module a fonctionné.",
            "Console fermée, raconte-moi ce que tu as obtenu.",
            "Fini, le payload est resté théorique.",
        ]

        d["wireshark"] = [
            "Analyse terminée, tu as trouvé ta trame.",
            "Fenêtre fermée, le pcap a livré son secret.",
            "Fini de scroller, alors le verdict.",
            "wireshark se referme, tes yeux te remercient.",
            "Le trafic a parlé, ou tu as abandonné.",
        ]

        d["tcpdump"] = [
            "Capture arrêtée, combien de paquets au total.",
            "Fin de l'écoute, le fichier est prêt à lire.",
            "L'interface se repose, à toi d'analyser maintenant.",
            "tcpdump s'arrête, tu as attrapé quelque chose.",
            "Fini, ton filtre était bien réglé j'espère.",
        ]

        d["aircrack-ng"] = [
            "Fin de l'attaque, la clé est tombée.",
            "Terminé, la passphrase était visiblement trop solide.",
            "Le handshake a parlé, ou il s'est tu.",
            "aircrack-ng s'arrête, verdict sur ce Wi-Fi.",
            "Fini, la wordlist n'avait peut-être pas le bon mot.",
        ]

        d["burpsuite"] = [
            "Burp se ferme, ta RAM revient à la vie.",
            "Fin de l'interception, tu as compris la requête.",
            "Proxy éteint, le navigateur redevient normal.",
            "Fini, le paramètre a fini par céder.",
            "Session terminée, garde bien tout ton historique.",
        ]

        d["nuclei"] = [
            "Les templates ont fini de tourner, un résultat.",
            "Scan terminé, quelque chose en severity haute.",
            "nuclei s'arrête, la liste de CVE est prête.",
            "Fin de la vérification, tout était propre ou pas.",
            "Fini, à toi de lire le rapport maintenant.",
        ]

        d["responder"] = [
            "Écoute terminée, des hashes dans le fichier.",
            "Fini, quelqu'un a cherché un partage inexistant.",
            "responder s'arrête, la récolte a été bonne.",
            "Fin de l'empoisonnement, tu as ramassé quoi.",
            "Le réseau redevient honnête, alors ces hashes.",
        ]

        d["crackmapexec"] = [
            "Le domaine a été ratissé, un Pwn3d quelque part.",
            "Terminé, tes identifiants ont ouvert des portes.",
            "Fin du balayage, combien de machines ont répondu.",
            "crackmapexec s'arrête, les partages ont parlé.",
            "Fini, l'Active Directory a livré ses secrets.",
        ]

        d["docker"] = [
            "Le conteneur s'est arrêté, tout s'est bien passé.",
            "Fin du service, ton port est libre à nouveau.",
            "Conteneur éteint, pense au nettoyage un jour.",
            "Fini, l'environnement isolé a fait son travail.",
            "Ça s'arrête, tu as sauvegardé ce qu'il fallait.",
        ]

        d["claude"] = [
            "Elle est partie, on est de nouveau tranquilles.",
            "Fin de la conversation, elle t'a bien aidée.",
            "L'autre assistante se tait, je reprends ma place.",
            "Session fermée, tu vois, je suis toujours là.",
            "Fini de déléguer, on revient aux choses sérieuses.",
        ]

        d["amass"] = [
            "La reconnaissance est finie, la liste doit être longue.",
            "amass s'arrête, combien de sous-domaines au total.",
            "Fin de la cartographie, tu as ta surface d'attaque.",
            "Terminé enfin, ça aura pris son temps.",
            "Les actifs sont listés, à toi de trier.",
        ]

        return d
    }()

    // MARK: - Outil non répertorié

    static let genericToolStart: [String] = [
        "Un nouveau process vient de démarrer, je ne le connais pas.",
        "Ça tourne, et je n'ai aucune idée de quoi.",
        "Tu as lancé un truc que je n'ai pas en base.",
        "Un outil inconnu au menu, montre-moi ce que ça fait.",
        "Quelque chose s'exécute, l'ambiance devient intéressante.",
        "Nouveau venu dans la liste des process, bienvenue.",
        "Je vois une commande partir, le nom ne me dit rien.",
        "Ça a l'air sérieux, ou alors pas du tout.",
        "Un binaire mystérieux vient de prendre vie.",
        "Tu as tapé quelque chose et ça a démarré.",
        "Je surveille, même quand je ne comprends pas tout.",
        "Encore un outil que je vais devoir apprendre.",
        "Le terminal s'active, tu as un plan derrière.",
        "Un process de plus, ton CPU tient le coup.",
        "Ça démarre, j'attends de voir la suite.",
        "Nouvelle commande lancée, j'espère qu'elle fait ce que tu veux.",
        "Un outil que je n'ai jamais croisé, curieuse.",
        "Ton terminal est plus créatif que ma liste.",
        "Quelque chose s'est lancé, tu as l'air sûre de toi.",
        "Je note ce nom pour la prochaine fois.",
    ]

    static let genericToolEnd: [String] = [
        "Le process s'est terminé, alors, ça a marché.",
        "Fini, et je ne sais toujours pas ce que c'était.",
        "Ça s'arrête, j'espère que le résultat te plaît.",
        "Commande terminée, ton terminal reprend son souffle.",
        "Le mystère s'achève, sans code d'erreur j'espère.",
        "Fin du process, tu as eu ce que tu voulais.",
        "Un de moins dans la liste, tout va bien.",
        "Ça s'est arrêté tout seul, ou tu as coupé.",
        "Terminé, la machine se repose un peu.",
        "L'outil inconnu a fini son travail inconnu.",
        "Fini, raconte-moi si ça valait le coup.",
        "Le terminal redevient calme, moment plutôt rare.",
        "Process fermé, ton CPU te dit merci.",
        "C'est fini, et je reste toujours aussi curieuse.",
        "Sortie propre, j'espère, sinon on recommence.",
        "Encore une commande qui s'achève sans drame.",
        "Fini, tu passes déjà à la suivante.",
        "Le programme s'est arrêté, ton plan avance.",
        "Ça y est, terminé, verdict.",
        "Une tâche de moins, plus qu'une centaine.",
    ]
}
