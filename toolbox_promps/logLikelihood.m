%function that compute the log likelihood
% If A positif symetric
% R = chol(A) where R'*R = A
function log_p = logLikelihood(x,mu,S)
    Sigma = chol(2*pi*S);
    logdetSigma = sum(log(diag(Sigma))); % logdetSigma
    log_p =  -2*logdetSigma -(1/2)*(x-mu)*(S\(x-mu)');  
end
