import { useState } from 'react';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Card, CardContent } from './ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Mail, Lock, UserCheck } from 'lucide-react';
import laJoyaLogo from 'figma:asset/573ae69949bb1650d02f03b6b86b01620a91b133.png';

interface LoginScreenProps {
  onLogin: (role: 'inspector' | 'gerente') => void;
}

export function LoginScreen({ onLogin }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<'inspector' | 'gerente'>('inspector');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onLogin(role);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10 flex items-center justify-center p-4">
      <div className="w-full max-w-sm">
        {/* Logo Section */}
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-24 h-16 bg-white rounded-2xl mb-6 shadow-lg shadow-primary/10 p-2">
            <img 
              src={laJoyaLogo} 
              alt="La Joya Avanza" 
              className="w-full h-full object-contain"
            />
          </div>
          <h1 className="text-primary mb-3 tracking-tight">Control de Fiscalización</h1>
          <p className="text-muted-foreground text-sm">
            Acceso para personal autorizado
          </p>
        </div>

        {/* Login Card */}
        <Card className="border-0 shadow-xl shadow-primary/5 rounded-3xl overflow-hidden">
          <CardContent className="p-8">
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="email" className="text-sm text-foreground/80">
                  Correo Electrónico
                </Label>
                <div className="relative">
                  <div className="absolute left-4 top-1/2 transform -translate-y-1/2">
                    <Mail className="w-5 h-5 text-muted-foreground" />
                  </div>
                  <Input
                    id="email"
                    type="email"
                    placeholder="usuario@municipalidad.gob.pe"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="pl-12 h-14 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors"
                    required
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="password" className="text-sm text-foreground/80">
                  Contraseña
                </Label>
                <div className="relative">
                  <div className="absolute left-4 top-1/2 transform -translate-y-1/2">
                    <Lock className="w-5 h-5 text-muted-foreground" />
                  </div>
                  <Input
                    id="password"
                    type="password"
                    placeholder="••••••••"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="pl-12 h-14 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors"
                    required
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label className="text-sm text-foreground/80">
                  Tipo de Usuario
                </Label>
                <div className="relative">
                  <div className="absolute left-4 top-1/2 transform -translate-y-1/2 z-10">
                    <UserCheck className="w-5 h-5 text-muted-foreground" />
                  </div>
                  <Select value={role} onValueChange={(value: 'inspector' | 'gerente') => setRole(value)}>
                    <SelectTrigger className="pl-12 h-14 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="inspector">Inspector de Campo</SelectItem>
                      <SelectItem value="gerente">Gerente / Administrador</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <Button 
                type="submit" 
                className="w-full h-14 bg-gradient-to-r from-primary to-red-600 hover:from-primary/90 hover:to-red-600/90 text-white rounded-2xl shadow-lg shadow-primary/25 border-0 transition-all duration-200 hover:shadow-xl hover:shadow-primary/30 hover:scale-[1.02]"
              >
                Iniciar Sesión
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Help Text */}
        <p className="text-center text-xs text-muted-foreground mt-8 leading-relaxed">
          Para obtener acceso, comuníquese con el<br />administrador del sistema.
        </p>
      </div>
    </div>
  );
}