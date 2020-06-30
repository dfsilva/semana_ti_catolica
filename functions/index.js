const functions = require('firebase-functions');
const admin = require("firebase-admin");
const serviceAccount = require("./firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://semana-ti-catolica.firebaseio.com"
});

const firestore = admin.firestore();


exports.atualizarUsuario = functions.storage.object().onFinalize(async (object) => {

    const bucket = admin.storage().bucket(object.bucket);
    const filePath = object.name;
    const file = bucket.file(filePath);

    const metadata = await file.getMetadata().then(([metadata])=>{
        return metadata;
    });

    const filePublicUrl = await file.getSignedUrl({
        action: 'read',
        expires: '01-01-2500'
    });

    const uid = metadata.metadata.uid;
    const userDoc = firestore.doc(`usuarios/${uid}`);

    await userDoc.set({
        foto: filePublicUrl[0]
    }, {merge: true})

    return "true";
});

