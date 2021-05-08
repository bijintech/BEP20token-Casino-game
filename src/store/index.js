import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    web3: null,
    diceContract: null,
    walletAddress: 'Connect Wallet',
    bscConnect: false,
    tokenBalance: 0.0,
    bnbBalance: 0.0
  },

  getters: {
    walletState: state => state,
    tokenBalance: state => state.tokenBalance,
    bnbBalance: state => state.bnbBalance,
  },

  mutations: {
    chageWalletState(state, walletState) {
      state.walletAddress = walletState.walletAddress
      state.web3 = walletState.web3
      state.bscConnect = walletState.bscConnect
      state.diceContract = walletState.diceContract
    },

    getBalance(state) {
      if (state.walletAddress !== "Connect Wallet") {
        state.diceContract.methods.balanceOf(state.walletAddress).call(
        ).then((res) => {
          state.tokenBalance = res / 100000000 //decimal is 8
        }).catch(() => {
          state.tokenBalance = 0
        })

        state.web3.eth.getBalance(state.walletAddress).then((res) => {
          state.bnbBalance = res / 1000000000000000000 //decimal is 18
        }).catch(() => {
          state.bnbBalance = 0
        })
      } else {
        state.tokenBalance = 0
        state.bnbBalance = 0
      }
    }
  }
});