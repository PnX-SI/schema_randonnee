Spécification des attributs du schéma des itinéraires de randonnées.

| Champs                 	| Type                 	| Format 	| Obligatoire 	| Description                                                                                                   	|
|------------------------	|----------------------	|--------	|-------------	|---------------------------------------------------------------------------------------------------------------	|
| id_local               	| chaîne de caractères 	|        	| Oui         	| Identifiant de l’objet dans sa BDD source                                                                     	|
| producteur             	| chaîne de caractères 	|        	| Oui         	| Structure(s) productrice(s) de l'itinéraire                                                                   	|
| contact                	| chaîne de caractères 	| email  	| Non         	| Contact de la structure publicatrice du jeu de données                                                        	|
| uuid                   	| chaîne de caractères 	| uuid   	| Non         	| Identifiant unique de type UUID                                                                               	|
| url                    	| chaîne de caractères 	| uri    	| Non         	| URL de la fiche source de l'itinéraire                                                                        	|
| id_osm                 	| nombre entier        	|        	| Non         	| Identifiant de la relation OSM correspondante                                                                 	|
| nom_itineraire         	| chaîne de caractères 	|        	| Oui         	| Nom de l'itinéraire                                                                                           	|
| geometry               	| chaîne de caractères 	| object 	| Oui         	| Géométrie linéaire de l’itinéraire                                                                            	|
| pratique               	| chaîne de caractères 	|        	| Oui         	| Pratique de l'itinéraire                                                                                      	|
| type_itineraire        	| chaîne de caractères 	|        	| Non         	| Type d'itinéraire                                                                                             	|
| communes_nom           	| chaîne de caractères 	|        	| Non         	| Noms des communes traversées par l'itinéraire                                                                 	|
| communes_code          	| chaîne de caractères 	|        	| Non         	| Codes INSEE des communes traversées par l'itinéraire                                                          	|
| depart                 	| chaîne de caractères 	|        	| Oui         	| Nom du point de départ                                                                                        	|
| arrivee                	| chaîne de caractères 	|        	| Oui         	| Nom du point d'arrivée                                                                                        	|
| duree                  	| nombre réel          	|        	| Non         	| Durée de l'itinéraire en heures                                                                               	|
| balisage               	| chaîne de caractères 	|        	| Non         	| Balisage(s) utilisé(s) sur l'itinéraire                                                                       	|
| longueur               	| nombre réel          	|        	| Non         	| Longueur de l'itinéraire (en mètres)                                                                          	|
| difficulte             	| chaîne de caractères 	|        	| Non         	| Difficulté de l'itinéraire                                                                                    	|
| altitude_max           	| nombre entier        	|        	| Non         	| Altitude maximum de l'itinéraire (en mètres)                                                                  	|
| altitude_min           	| nombre entier        	|        	| Non         	| Altitude minimum de l'itinéraire (en mètres)                                                                  	|
| denivele_positif       	| nombre entier        	|        	| Non         	| Dénivelé positif de l'itinéraire (en mètres)                                                                  	|
| denivele_negatif       	| nombre entier        	|        	| Non         	| Dénivelé négatif de l'itinéraire (en mètres)                                                                  	|
| instructions           	| chaîne de caractères 	|        	| Oui         	| Description détaillée (pas à pas) du tracé de l'itinéraire                                                    	|
| presentation           	| chaîne de caractères 	|        	| Non         	| Présentation détaillée de l'itinéraire                                                                        	|
| presentation_courte    	| chaîne de caractères 	|        	| Non         	| Présentation courte résumant l'itinéraire                                                                     	|
| themes                 	| chaîne de caractères 	|        	| Non         	| Thèmes ou mots-clefs caractérisant l'itinéraire                                                               	|
| recommandations        	| chaîne de caractères 	|        	| Non         	| Recommandations sur l'itinéraire                                                                              	|
| accessibilite          	| chaîne de caractères 	|        	| Non         	| Accessibilité de l'itinéraire à des publics particuliers                                                      	|
| acces_routier          	| chaîne de caractères 	|        	| Non         	| Informations sur les accès routiers                                                                           	|
| transports_commun      	| chaîne de caractères 	|        	| Non         	| Informations sur les accès en transports en commun                                                            	|
| parking_info           	| chaîne de caractères 	|        	| Non         	| Informations sur le parking                                                                                   	|
| parking_geometrie      	| chaîne de caractères 	|        	| Non         	| Localisation du parking                                                                                       	|
| date_creation          	| chaîne de caractères 	| date   	| Non         	| Date de création de l'itinéraire dans sa BDD source (AAAA-MM-JJ)                                              	|
| date_modification      	| chaîne de caractères 	| date   	| Non         	| Date de dernière modification de l'itinéraire dans sa BDD source (AAAA-MM-JJ)                                 	|
| medias                 	| tableau              	|        	| Non         	| Médias de l’itinéraire (photos, vidéos, audios, documents) avec titre, légende, type, url, auteur et licence) 	|
| itineraire_parent      	| chaîne de caractères 	|        	| Non         	| id_local de l'itinéraire parent dans sa BDD source                                                            	|
| type_sol               	| chaîne de caractères 	|        	| Non         	| Types de sol sur lesquels se parcourt l'itinéraire                                                            	|
| pdipr_inscription      	| booléen              	|        	| Non         	| Inscription au PDIPR                                                                                          	|
| pdipr_date_inscription 	| chaîne de caractères 	| date   	| Non         	| Date d'inscription au PDIPR (AAAA-MM-JJ)                                                                      	|
