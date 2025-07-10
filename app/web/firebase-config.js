// Firebase設定 - tcgtournamentmanagerdev プロジェクト用
// 実際の設定値はFirebaseコンソールから取得して置き換えてください
const firebaseConfig = {
  apiKey: "your-api-key-here",
  authDomain: "tcgtournamentmanagerdev.firebaseapp.com",
  projectId: "tcgtournamentmanagerdev",
  storageBucket: "tcgtournamentmanagerdev.appspot.com",
  messagingSenderId: "your-sender-id-here",
  appId: "your-app-id-here"
};

// Firebase初期化
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);