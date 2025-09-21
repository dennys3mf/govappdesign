import { Button } from './ui/button';
import { Card, CardContent } from './ui/card';
import { 
  Printer, 
  FileText, 
  LogOut, 
  User,
  Plus,
  ChevronRight,
  BarChart3
} from 'lucide-react';
import laJoyaLogo from 'figma:asset/573ae69949bb1650d02f03b6b86b01620a91b133.png';

interface HomeScreenProps {
  onNavigate: (screen: string) => void;
  onLogout: () => void;
  userName?: string;
}

export function HomeScreen({ onNavigate, onLogout, userName = "Inspector" }: HomeScreenProps) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
        <div className="max-w-lg mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-12 h-8 bg-white rounded-xl flex items-center justify-center p-1 shadow-sm">
              <img 
                src={laJoyaLogo} 
                alt="La Joya" 
                className="w-full h-full object-contain"
              />
            </div>
            <h1 className="text-primary tracking-tight">Fiscalización</h1>
          </div>
          <Button 
            variant="ghost" 
            onClick={onLogout}
            className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
          >
            <LogOut className="w-4 h-4" />
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-lg mx-auto px-6 py-8">
        {/* Welcome Section */}
        <div className="mb-8">
          <div className="flex items-center space-x-3 mb-2">
            <div className="w-8 h-8 bg-gradient-to-br from-primary/20 to-red-600/20 rounded-full flex items-center justify-center">
              <User className="w-4 h-4 text-primary" />
            </div>
            <h2 className="text-foreground">Hola, {userName}</h2>
          </div>
          <p className="text-muted-foreground text-sm">
            ¿Qué necesitas hacer hoy?
          </p>
        </div>

        {/* Action Cards */}
        <div className="space-y-4">
          {/* Nueva Fiscalización - Primary Action */}
          <Card 
            className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden cursor-pointer hover:shadow-xl hover:shadow-primary/15 transition-all duration-300 hover:scale-[1.02] bg-gradient-to-br from-white to-red-50/30"
            onClick={() => onNavigate('inspection')}
          >
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-gradient-to-br from-primary to-red-600 rounded-2xl flex items-center justify-center">
                    <Plus className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h3 className="text-foreground mb-1">Nueva Fiscalización</h3>
                    <p className="text-muted-foreground text-sm">
                      Iniciar inspección vehicular
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>

          {/* Configurar Impresora */}
          <Card 
            className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden cursor-pointer hover:shadow-xl hover:shadow-primary/15 transition-all duration-300 hover:scale-[1.02] bg-white"
            onClick={() => onNavigate('printer')}
          >
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl flex items-center justify-center">
                    <Printer className="w-7 h-7 text-gray-600" />
                  </div>
                  <div>
                    <h3 className="text-foreground mb-1">Configurar Impresora</h3>
                    <p className="text-muted-foreground text-sm">
                      Configurar dispositivo
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>

          {/* Dashboard Administrativo */}
          <Card 
            className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden cursor-pointer hover:shadow-xl hover:shadow-primary/15 transition-all duration-300 hover:scale-[1.02] bg-gradient-to-br from-white to-blue-50/30"
            onClick={() => onNavigate('dashboard')}
          >
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl flex items-center justify-center">
                    <BarChart3 className="w-7 h-7 text-white" />
                  </div>
                  <div>
                    <h3 className="text-foreground mb-1">Dashboard</h3>
                    <p className="text-muted-foreground text-sm">
                      Estadísticas y reportes
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>

          {/* Historial de Boletas */}
          <Card 
            className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden cursor-pointer hover:shadow-xl hover:shadow-primary/15 transition-all duration-300 hover:scale-[1.02] bg-white"
            onClick={() => onNavigate('history')}
          >
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-4">
                  <div className="w-14 h-14 bg-gradient-to-br from-red-100 to-red-200 rounded-2xl flex items-center justify-center">
                    <FileText className="w-7 h-7 text-red-600" />
                  </div>
                  <div>
                    <h3 className="text-foreground mb-1">Historial de Boletas</h3>
                    <p className="text-muted-foreground text-sm">
                      Ver boletas emitidas
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-muted-foreground" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Status Info */}
        <div className="mt-12 p-4 bg-white/60 backdrop-blur-sm rounded-2xl border border-primary/10">
          <div className="flex items-center justify-between text-sm">
            <span className="text-muted-foreground">Estado del sistema</span>
            <div className="flex items-center space-x-2">
              <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
              <span className="text-emerald-600">Operativo</span>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}