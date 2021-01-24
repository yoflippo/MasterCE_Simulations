function [x_UKF, P, K, Pp] = UKF_RTS_smooth(x_UKF, Ps, handleF, Q)

x_UKF = Xs;
P = Ps;
Pp = Ps;

for k = length(Xs)-1:-1:1
    Pp(k).M = handleF * P(k).M * handleF' + Q;
    K(k).M = P(k).M * handleF' * inv(Pp(k).M);
    x_UKF(k,:) = x_UKF(k,:) + (K(k).M * (x_UKF(k+1,:) - (handleF*x_UKF(k,:)')')')';
    P(k).M = P(k).M + (K(k).M * (P(k+1).M - Pp(k).M) * K(k).M');
end
end

%%     def rts_smoother(self, Xs, Ps, Qs=None, dts=None, UT=None):
%         """
%         Runs the Rauch-Tung-Striebel Kalman smoother on a set of
%         means and covariances computed by the UKF. The usual input
%         would come from the output of `batch_filter()`.
%         Parameters
%         ----------
%         Xs : numpy.array
%            array of the means (state variable x) of the output of a Kalman
%            filter.
%         Ps : numpy.array
%             array of the covariances of the output of a kalman filter.
%         Qs: list-like collection of numpy.array, optional
%             Process noise of the Kalman filter at each time step. Optional,
%             if not provided the filter's self.Q will be used
%         dt : optional, float or array-like of float
%             If provided, specifies the time step of each step of the filter.
%             If float, then the same time step is used for all steps. If
%             an array, then each element k contains the time  at step k.
%             Units are seconds.
%         UT : function(sigmas, Wm, Wc, noise_cov), optional
%             Optional function to compute the unscented transform for the sigma
%             points passed through hx. Typically the default function will
%             work - you can use x_mean_fn and z_mean_fn to alter the behavior
%             of the unscented transform.
%         Returns
%         -------
%         x : numpy.ndarray
%            smoothed means
%         P : numpy.ndarray
%            smoothed state covariances
%         K : numpy.ndarray
%             smoother gain at each step
%         Examples
%         --------
%         .. code-block:: Python
%             zs = [t + random.randn()*4 for t in range (40)]
%             (mu, cov, _, _) = kalman.batch_filter(zs)
%             (x, P, K) = rts_smoother(mu, cov, fk.F, fk.Q)
%         """
%         #pylint: disable=too-many-locals, too-many-arguments
% 
%%         if len(Xs) != len(Ps):
%             raise ValueError('Xs and Ps must have the same length')
% 
%         n, dim_x = Xs.shape
% 
%         if dts is None:
%             dts = [self._dt] * n
%         elif isscalar(dts):
%             dts = [dts] * n
% 
%         if Qs is None:
%             Qs = [self.Q] * n
% 
%         if UT is None:
%             UT = unscented_transform
% 
%         # smoother gain
%         Ks = zeros((n, dim_x, dim_x))
% 
%         num_sigmas = self._num_sigmas
% 
%         xs, ps = Xs.copy(), Ps.copy()
%         sigmas_f = zeros((num_sigmas, dim_x))
% 
%         for k in reversed(range(n-1)):
%             # create sigma points from state estimate, pass through state func
%             sigmas = self.points_fn.sigma_points(xs[k], ps[k])
%             for i in range(num_sigmas):
%                 sigmas_f[i] = self.fx(sigmas[i], dts[k])
% 
%             xb, Pb = UT(
%                 sigmas_f, self.Wm, self.Wc, self.Q,
%                 self.x_mean, self.residual_x)
% 
%             # compute cross variance
%             Pxb = 0
%             for i in range(num_sigmas):
%                 y = self.residual_x(sigmas_f[i], xb)
%                 z = self.residual_x(sigmas[i], Xs[k])
%                 Pxb += self.Wc[i] * outer(z, y)
% 
%             # compute gain
%             K = dot(Pxb, self.inv(Pb))
% 
%             # update the smoothed estimates
%             xs[k] += dot(K, self.residual_x(xs[k+1], xb))
%             ps[k] += dot(K, ps[k+1] - Pb).dot(K.T)
%             Ks[k] = K
% 
%         return (xs, ps, Ks)