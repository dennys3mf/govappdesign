import { useState } from "react";
import { LoginScreen } from "./components/LoginScreen";
import { HomeScreen } from "./components/HomeScreen";
import { InspectionForm } from "./components/InspectionForm";
import { PrinterScreen } from "./components/PrinterScreen";
import { HistoryScreen } from "./components/HistoryScreen";
import { Dashboard } from "./components/Dashboard";
import { AdminDashboard } from "./components/AdminDashboard";

type Screen =
  | "login"
  | "home"
  | "inspection"
  | "printer"
  | "history"
  | "dashboard"
  | "admin";
type UserRole = "inspector" | "gerente";

export default function App() {
  const [currentScreen, setCurrentScreen] =
    useState<Screen>("login");
  const [user, setUser] = useState<{
    name: string;
    role: UserRole;
  } | null>(null);

  const handleLogin = (role: UserRole) => {
    if (role === "gerente") {
      setUser({ name: "Gerente Municipal", role: "gerente" });
      setCurrentScreen("admin");
    } else {
      setUser({
        name: "Inspector Municipal",
        role: "inspector",
      });
      setCurrentScreen("home");
    }
  };

  const handleLogout = () => {
    setUser(null);
    setCurrentScreen("login");
  };

  const handleNavigate = (screen: string) => {
    switch (screen) {
      case "inspection":
        setCurrentScreen("inspection");
        break;
      case "printer":
        setCurrentScreen("printer");
        break;
      case "history":
        setCurrentScreen("history");
        break;
      case "dashboard":
        setCurrentScreen("dashboard");
        break;
      case "admin":
        setCurrentScreen("admin");
        break;
      default:
        if (user?.role === "gerente") {
          setCurrentScreen("admin");
        } else {
          setCurrentScreen("home");
        }
    }
  };

  const renderScreen = () => {
    switch (currentScreen) {
      case "login":
        return <LoginScreen onLogin={handleLogin} />;
      case "home":
        return (
          <HomeScreen
            onNavigate={handleNavigate}
            onLogout={handleLogout}
            userName={user?.name}
          />
        );
      case "inspection":
        return (
          <InspectionForm
            onBack={() => setCurrentScreen("home")}
          />
        );
      case "printer":
        return (
          <PrinterScreen
            onBack={() => setCurrentScreen("home")}
          />
        );
      case "history":
        return (
          <HistoryScreen
            onBack={() => setCurrentScreen("home")}
          />
        );
      case "dashboard":
        return (
          <Dashboard onBack={() => setCurrentScreen("home")} />
        );
      case "admin":
        return (
          <AdminDashboard
            onLogout={handleLogout}
            userName={user?.name}
          />
        );
      default:
        return <LoginScreen onLogin={handleLogin} />;
    }
  };

  return (
    <div className="font-sans antialiased">
      {renderScreen()}
    </div>
  );
}