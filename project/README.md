# app

## tech

### backedn

* graphql
* go, nodejs, rust as backedn
* flutter as frontend

## MUST

* 0 error, 0 warming
* 0 runtime exception(android + web + ios)Except for one situation： (may be flutter engine error, before fix, if package error, if easy to fix, use as local package then fix it, otherwise, wait)

## MUST2

* all repository related to state, should use bloc to call it's method

## bloc nested solution

* global state(whole app life cycle) in app
* template state in route state wrapper

## router

* all use top route, easy to route
* which page use template state, the page route use wrapper route
* which page pop, want to show other route page, use popAndPushAll[...]

## micro k8s service principle

* every concept a service
  * authentication service(sign in/sign up & issue token), 
  * user service(query user, modify user)
  * contacts service(need merge to user service for data sharing)
  * chat & message service
  * object storage service
  * stun/turn service
  * sfu service
* may be need add a layer(protection service)


## Nomenclature

* Add to a list
* Remove from a list
* Create a new entity
* Non-permanently hide or archive an entity
* Permanently delete an entity
* Irreversibly shred or obliterate an entity
* Update, modify, or edit an entity or value
* Update, modify, edit, or change a value
* Read or view an entity or value



## commonly used cmd

flutter pub run build_runner build
flutter pub run build_runner watch
export ANDROID_HOME=/Users/bryan.wu/Library/Android/sdk
flutter build apk --split-per-abi
flutter packages pub run build_runner watch    
flutter packages pub run build_runner build    


