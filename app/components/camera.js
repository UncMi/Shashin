let cameras;

async function main() {
  await initializeWidgetsFlutterBinding();
  cameras = await availableCameras();
  runApp();
}

async function initializeWidgetsFlutterBinding() {}

async function availableCameras() {
    return ['camera1', 'camera2'];
}

function runApp() {
    const appElement = document.getElementById("app");
  appElement.innerHTML = "<h1>My Flutter App</h1><p>Cameras: " + cameras.join(", ") + "</p>";
}

main();